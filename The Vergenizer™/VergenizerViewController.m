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
@property (strong, nonatomic) AssetObject *segueAssetObject;

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

            self.segueAssetObject = vergenizerCVC.assetObject;
        }
        [self performSegueWithIdentifier:@"vergenizerDetailSegue" sender:self];
    }
    
}



//Delegate method. We union new objects into the URLString set so that we don't get dupes.
-(void)addAssetObjectSet:(NSSet *)objects{
    
    [self.assetObjectSet unionSet:objects];
}

#pragma delegate methods

//This orderedURLStringSet is tracking everything -- how many assets we have onscreen, what their URLs are, etc.
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numCells = self.assetObjectSet.count;
    return numCells;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
// So where are the actual cells coming from? They should be tied to some piece of data that's independent of the collectionView.
// So I guess the orderedSet. That means:
//              - when we ask for cell at index path we get the tail integer (indexPath.item) and ask for the asset at that index in the set.
//              - when we clear we remove items from the collection at all index paths (0 to orderedURLStringSet.count - 1)

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vergenizerCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[VergenizerCVC class]]) {
        
        //Get the asset that's going in the collection view
        VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
        AssetObject *assetObject = self.assetObjectSet[indexPath.item];
        vergenizerCVC.assetObject = assetObject;
        [vergenizerCVC syncImage];
    }
    return cell;
    
}



#pragma actions

- (IBAction)clearButton:(id)sender {
    [self.assetObjectSet removeAllObjects];
    [self.collectionView reloadData];
//    [self.wmHandler.details removeAllObjects];
    self.navigationItem.prompt = nil;
}

- (IBAction)vergenizeButton:(id)sender {
    NSLog(@"VergenizeButton");
    NSLog(@"Groups count: %d", self.handler.groups.count);
    for (int i = 0; i<self.handler.groups.count; i++) {
        NSLog(@"inside for loop");
        if ([self.handler.groups[i] isKindOfClass:[ALAssetsGroup class]]) {
            NSLog(@"class matches");
            ALAssetsGroup *thisGroup = self.handler.groups[i];
            NSLog(@"This group's name is %@", [thisGroup valueForProperty:ALAssetsGroupPropertyName]);
            if ([[thisGroup valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Vergenized"]) {
                NSLog(@"Vergenized group found");
                [self waterMarkPhotosIntoGroup:thisGroup];
                return;
            }
        }
    }
    NSLog(@"Creating Vergenized group");
    [self.handler addAssetGroupWithName:@"Vergenized"];
    [self vergenizeButton:self];
}

#warning need to fix vergenized group not appearing on second "plus button" press

-(void)waterMarkPhotosIntoGroup:(ALAssetsGroup *)group{
    NSLog(@"Watermarking photos into group");
    for (int i=0; i<self.assetObjectSet.count; i++) {
        if ([self.assetObjectSet[i] isKindOfClass:[AssetObject class]]) {
            AssetObject *thisAssetObject = (AssetObject *)self.assetObjectSet[i];
            ALAssetRepresentation *thisRep = [thisAssetObject.asset defaultRepresentation];
            ALAssetOrientation orientation = [thisRep orientation];
            UIImage *sourceImage = [UIImage imageWithCGImage:[thisRep fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)orientation];
            
            if (!sourceImage) {
                [NSException raise:@"No source image" format:@"You tried to create a sourceImage from an ALAssetRepresentation but it didn't work"];
            } else if (sourceImage){
                NSLog(@"We have a sourceImage. It's %f by %f", sourceImage.size.width, sourceImage.size.height);
            }
            CGImageRef cgImage = [sourceImage CGImage];
            if (!cgImage) {
                [NSException raise:@"No CGImageRef" format:@"You tried to create a CGImageRef from a UIImage but it didn't work"];
            } else if (cgImage) {
                NSLog(@"We have a cgImage. It's %zu by %zu", CGImageGetWidth(cgImage), CGImageGetHeight(cgImage));
            }
            
            CGSize targetSize = CGSizeMake(thisAssetObject.outputSize, thisAssetObject.outputSize * CGImageGetHeight(cgImage) / CGImageGetWidth(cgImage));
            NSLog(@"Our targetSize is %f by %f", targetSize.width, targetSize.height);
            CGRect targetRect = CGRectMake(0.0, 0.0, targetSize.width, targetSize.height);
            
            //Creating the "context" -- the opaque data type where our drawing happens. Ugh, Core Graphics.
#warning Need to sort out this bytesperrow thing
            CGContextRef thisContext = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(cgImage), [self bytesPerRowForWidth:targetSize.width WithBitsPerPixel:CGImageGetBitsPerPixel(cgImage)], CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage));
            
            NSLog(@"The context is %zu by %zu \n sourceImage is %f by %f \n targetSize is %f by %f", CGBitmapContextGetWidth(thisContext), CGBitmapContextGetHeight(thisContext), sourceImage.size.width, sourceImage.size.height, targetSize.width, targetSize.height);
            
            //Draw our image onto the context.
            CGContextDrawImage(thisContext, targetRect, cgImage);

#warning need to rewrite this
            UIImage *watermarkImage = [UIImage imageNamed:thisAssetObject.watermarkString];
            if (!watermarkImage) {
                [NSException raise:@"No watermark image" format:@"The watermark image you asked for doesn't exist"];
            }
            CGContextSaveGState(thisContext);
            CGContextSetAlpha(thisContext, 0.2);
            CGImageRef watermarkRef = [watermarkImage CGImage];
            
#warning Need constants for these values
            CGRect watermarkRect = CGRectMake(targetSize.width - watermarkImage.size.width - targetSize.width * 0.016, targetSize.width*0.016, watermarkImage.size.width, watermarkImage.size.height);
            CGContextDrawImage(thisContext, watermarkRect, watermarkRef);
            CGImageRef finalImage = CGBitmapContextCreateImage(thisContext);
            
            ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *assetURL, NSError *error){
                
                NSLog(@"Success!");
                
                //Don't forget to release all your Core Graphics stuff
                CGContextRelease(thisContext);
            };

            [self.handler.library writeImageToSavedPhotosAlbum:finalImage orientation:orientation completionBlock:completionBlock];
            
        }
    }

}

- (int)bytesPerRowForWidth:(int)width WithBitsPerPixel:(int)bits{
    int bytes;
    bytes = (int)(bits*4*width);
    if (bytes%16 != 0) {
        bytes = bytes+15 - (bytes+15)%16;   //gets bytes up over the next highest multiple of 16 and subtracts the unused part
    }
    return bytes;
}

//lowest multiple of 2:
//start at 3, add 2-1 = 1 to get it 'up over'


#pragma lifecycle methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        PickerViewController *pvc;
        pvc = segue.destinationViewController;
        pvc.handler = self.handler;
    }
    if ([segue.identifier isEqualToString:@"vergenizerDetailSegue"]) {
        if ([segue.destinationViewController conformsToProtocol:@protocol(DetailDelegate)]) {
            self.detailDelegate = segue.destinationViewController;
            self.detailDelegate.assetObject = self.segueAssetObject;
            self.detailDelegate.assetObjectSet = self.assetObjectSet;
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
}


- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"Inside VWA");
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.assetObjectSet.count == 0){
        self.navigationItem.prompt = nil;
    } else {
        self.navigationItem.prompt = @"Tap photos to edit";
    }
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.collectionView layoutIfNeeded];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableOrderedSet *)assetObjectSet{
    if (!_assetObjectSet) {
        _assetObjectSet = [[NSMutableOrderedSet alloc]init];
    }
    return _assetObjectSet;
}





@end