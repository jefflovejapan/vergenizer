//
//  VergenizerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 6/30/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerViewController.h"
#import "PickerViewController.h"
#import "VergenizerCVC.h"
#import "AssetObject.h"


@interface VergenizerViewController ()

//Used in segue to detai view for setting watermark params
@property (strong, nonatomic) ALAsset *segueAsset;

//An array, used like a queue, to manage which index paths to reload when the model gets new images
@property (strong, nonatomic) NSMutableArray *indexPathstoReload;
@end

@implementation VergenizerViewController

//Returns when collectionViewCell is tapped
- (IBAction)vergenizerCellTap:(id)sender {
    CGPoint tapLocation = [sender locationInView:self.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[VergenizerCVC class]]) {
            //Say we tap on the image with index.item == 1. We want the asset at the URL in index 1.
            VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;

            self.segueAsset = vergenizerCVC.asset;
        }
        [self performSegueWithIdentifier:@"vergenizerDetailSegue" sender:self];
    }
    
}



//Delegate method. We union new objects into the URL set so that we don't get dupes.
-(void)addURLSet:(NSSet *)objects{
    [self.orderedURLSet unionSet:objects];
}

#pragma delegate methods

//This orderedURLSet is tracking everything -- how many assets we have onscreen, what their URLs are, etc.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numCells = self.orderedURLSet.count;
    return numCells;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
// So where are the actual cells coming from? They should be tied to some piece of data that's independent of the collectionView.
// So I guess the orderedSet. That means:
//              - when we ask for cell at index path we get the tail integer (indexPath.item) and ask for the asset at that index in the set.
//              - when we clear we remove items from the collection at all index paths (0 to orderedURLSet.count - 1)


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vergenizerCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[VergenizerCVC class]]) {
        
        //Get the asset that's going in the collection view
        NSURL *assetURL = self.orderedURLSet[indexPath.item];
        
        
        //Add the indexPath to our indexPath queue so our model knows this cell needs an image. Image gets returned asynchronously, so won't be back by the time cell needs to be redrawn
        [self addIndexPathtoQueue:indexPath];
        
        //This fires off a request for the ALAsset in a separate thread. Gets returned in reloadNextIndexPathWithAsset
        [self.handler assetForURL:assetURL];
        
        
        
    }
    return cell;
    
}


//All this stuff is predicated on the idea of getting an asset back from the PhotoHandler. No need for separate array of assets to reload.

//Getting and displaying image from PhotoHandler
-(void)reloadNextIndexPathWithAsset:(ALAsset*)asset{
    
    
    if (self.indexPathstoReload[0] && [self.indexPathstoReload[0] isKindOfClass:[NSIndexPath class]]) {
        
        //Grabbing the next indexPath and removing it from the queue in one step
        NSIndexPath *indexPath = [self removeNextIndexPathFromQueue];
        
        UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[VergenizerCVC class]]) {
            VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
            vergenizerCVC.asset = asset;
            [vergenizerCVC syncImage];
            [vergenizerCVC setNeedsDisplay];
            //Add the URL to the dictionary that's going to track all of the watermark parameters
            [self addAsset:asset toWMHandler:self.wmHandler];
        }
        
    } else {
        [NSException raise:@"Too few indexPaths" format:@"Delegate requested another indexPath, but there are none left in the queue to reload."];
    }
}

- (CGImageRef)getThumbnailForAsset:(ALAsset*)asset{
    //This method below is asynchronous, and won't give a return value. Need to reload data in the collectionView after it returns
    return [asset thumbnail];
}




- (void)addAsset:(ALAsset *)asset toWMHandler:(WatermarkHandler *)wmHandler{
    
    //Need a string for dictionary key
    NSString *thisString = [[asset valueForProperty:ALAssetPropertyAssetURL]absoluteString];
    
    //Add this key and its associated object to the dictionary if it's not already there
    if (![wmHandler.details objectForKey:thisString]) {
        [wmHandler addNewObjectWithString:thisString andAsset:asset];
        NSLog(@"Just called for a new object in wmHandler");
    }
}


// Managing the queue of indexPaths to reload. Need to do this because ALAssets are coming back from the PhotoHandler asynchronously
-(void)addIndexPathtoQueue:(NSIndexPath *) indexPath{
    [self.indexPathstoReload addObject:indexPath];
}


//Returning the next indexPath in the queue and removing it from the queue. This is the method that should be called when we need to get a new indexPath.
-(NSIndexPath* )removeNextIndexPathFromQueue{
    if (self.indexPathstoReload[0]) {
        NSIndexPath *returnPath = self.indexPathstoReload[0];
        [self.indexPathstoReload removeObjectAtIndex:0];
        NSLog(@"About to return an indexPath from indexPathstoReload. Count is now %d", self.indexPathstoReload.count);
        return returnPath;
    }else{
        NSLog(@"There's no indexPath at 0. Something went wrong.");
        return nil;
    }
    
}



#pragma actions

- (IBAction)clearButton:(id)sender {
    [self.orderedURLSet removeAllObjects];
    [self.collectionView reloadData];
    [self.wmHandler.details removeAllObjects];
    self.navigationItem.prompt = nil;
}

- (IBAction)vergenizeButton:(id)sender {
    NSLog(@"VergenizeButton");
    for (int i = 0; i<self.groups.count; i++) {
        NSLog(@"inside for loop");
        if ([self.groups[i] isKindOfClass:[ALAssetsGroup class]]) {
            NSLog(@"class matches");
            ALAssetsGroup *thisGroup = self.groups[i];
            if ([[thisGroup valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Vergenized"]) {
                NSLog(@"Vergenized group found");
                [self waterMarkPhotosIntoGroup:thisGroup];
                return;
            }
        }
    }
    NSLog(@"Creating Vergenized group");
    [self.handler addAssetGroupWithName:@"Vergenized"];
#warning need to fix vergenized group not appearing on second "plus button" press
}

-(void) waterMarkPhotosIntoGroup:(ALAssetsGroup *)group{
    NSLog(@"Watermarking photos into group");
//    NSArray *keys = [self.wmHandler.details allKeys];
//    for (int i = 0; i<keys.count; i++) {
//        NSObject *thisObject = [self.wmHandler.details objectForKey:keys[i]];
//        if ([thisObject isKindOfClass:[AssetObject class]]) {
//            NSLog(@"thisObject is AssetObject. Beginning watermarking");
//            AssetObject *assetObject = (AssetObject *)thisObject;
//            ALAssetRepresentation *assetRep = [assetObject.asset defaultRepresentation];
//            ALAssetOrientation orientation = [assetRep orientation];
//            CGImageRef *ref = [assetRep fullResolutionImage];
//    }
}


#pragma lifecycle methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        self.picker = (PickerViewController *)segue.destinationViewController;
        self.picker.handlerDelegate = self;
    }
    if ([segue.identifier isEqualToString:@"vergenizerDetailSegue"]) {
        if ([segue.destinationViewController conformsToProtocol:@protocol(DetailDelegate)]) {
            self.detailDelegate = segue.destinationViewController;
            self.detailDelegate.asset = self.segueAsset;
            self.detailDelegate.handler = self.wmHandler;
        }
    }

}

- (IBAction)unwindToVergenizerViewController:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"%@", [self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#warning Not sure where else to put this initialization code. Doesn't seem safe to just be instantiating once in viewDidLoad rather than use lazy instantiation.
    self.handler = [[PhotoHandler alloc]init];
    self.handler.assetBlockDelegate = self;
}


- (void)viewWillAppear:(BOOL)animated{
    if(self.orderedURLSet.count == 0){
        self.navigationItem.prompt = nil;
    } else {
        self.navigationItem.prompt = @"Tap photos to edit";
    }
    [self.collectionView reloadData];
    [self.collectionView layoutSubviews];
    [self.collectionView setNeedsDisplay];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableOrderedSet *)orderedURLSet{
    if (!_orderedURLSet) {
        _orderedURLSet = [[NSMutableOrderedSet alloc]init];
    }
    return _orderedURLSet;
}

- (WatermarkHandler *)wmHandler{
    if (!_wmHandler) {
        _wmHandler = [[WatermarkHandler alloc]init];
    }
    return _wmHandler;
}

- (NSMutableArray *) indexPathstoReload{
    if (!_indexPathstoReload) {
        _indexPathstoReload = [[NSMutableArray alloc]init];
    }
    return _indexPathstoReload;
}



@end