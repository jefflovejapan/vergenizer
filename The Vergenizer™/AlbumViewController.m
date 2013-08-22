//
//  AlbumViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumViewController ()

//Used in segue to ImageViewController
@property (strong, nonatomic) ALAsset *segueAsset;

//Used rather than array to check for dupes. Gets new photos unioned into set via 
@property (strong, nonatomic) NSMutableSet *assetObjectSet;




@end

@implementation AlbumViewController

#pragma Actions

//Gets triggered when tapping the "select" button. Should probably rename.
- (IBAction)selectButtonTap:(id)sender {
    if (!self.selectionMode) {
        [self enterSelectionMode];
    } else {
        
        [self exitSelectionMode];
    }
}

//Needs to be implemented. Take an array/set of selected assets and send them back to VergenizerViewController for watermarking.
- (IBAction)addSelectedButton:(id)sender {
    NSArray *controllers = [self.navigationController viewControllers];
    if ([controllers[0] conformsToProtocol:@protocol(VergenizerDelegate)]) {
        self.vergenizerDelegate = controllers[0];
        [self.vergenizerDelegate addAssetObjectSet:self.assetObjectSet];
        NSLog(@"The length of self.assetObjectSet is %d", self.assetObjectSet.count);
    }
    NSLog(@"Popping to root");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//Gets triggered when someone taps an image (AssetView) in UICollectionView. What happens depends on the current state of the UI
- (IBAction)tap:(UITapGestureRecognizer *)sender {
    CGPoint tapLocation = [sender locationInView:self.albumCollectionView];
    NSIndexPath *indexPath = [self.albumCollectionView indexPathForItemAtPoint:tapLocation];
    UICollectionViewCell *cell = [self.albumCollectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        //If we're in the right mode for selecting images
        if (self.selectionMode) {
            //A tap flips the cell's checkmark
            [self flipCheckmarkAtIndexPath:indexPath];
        } else {
            //Otherwise, we go to a fullscreen view of the image
            [self goBig:indexPath];
            
        }
    }
    
}

#pragma Private Methods

-(void) goBig:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.albumCollectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:[AlbumCVC class]]) {
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        self.segueAsset = albumCVC.assetObject.asset;
        [self performSegueWithIdentifier:@"bigImageSegue" sender:self];
    }
}

//This is the main logic for managing checkmark flips. The checkmarks themselves are based on BOOLs set in the albumCVCs. When this method gets called we do the following:
//  - check the value of the BOOL
//  - if it's NO then there's currently no checkmark. Therefore:
//      - switch the BOOL to YES
//      - make the checkMarkView visible in albumCVC
//      - add the asset to self.URLSet
//  - if it's YES then we already have a checkmark and the user is deselecting. Therefore:
//      - switch the BOOL to NO
//      - make the checkMarkView invisible in albumCVC
//      - remove the asset from self.URLSet

- (void) flipCheckmarkAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [self.albumCollectionView cellForItemAtIndexPath:indexPath];
    if (cell && [cell isKindOfClass:[AlbumCVC class]]) {
        NSLog(@"cell exists and is albumCVC class");
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        
        NSLog(@"checkmarkHidden: %d", albumCVC.assetObject.checkmarkHidden);
        NSString *URLString = albumCVC.assetObject.URLString;
        NSLog(@"albumCVC.assetObject exists? %d", (albumCVC.assetObject) ? 1:0);
        NSLog(@"Just got assetURL. It's %@", URLString);
        if (albumCVC.assetObject.checkmarkHidden) {
            //This URLSet is used to keep track of which images to send back to VergenizerViewController for watermarking
            [self.assetObjectSet addObject:albumCVC.assetObject];
            albumCVC.assetObject.checkmarkHidden = !albumCVC.assetObject.checkmarkHidden;
            [albumCVC syncCheckmark];
        } else if (!albumCVC.assetObject.checkmarkHidden) {
            //A tap means we should add this asset to our URLSet
            [self.assetObjectSet removeObject:albumCVC.assetObject];
            albumCVC.assetObject.checkmarkHidden = !albumCVC.assetObject.checkmarkHidden;
            [albumCVC syncCheckmark];
        } else {
            [NSException raise:@"Invalid checkmark state" format:@"Value for boolean checkmarkIsHidden neither YES nor NO"];
        }
        
    }
    
}

-(void)enterSelectionMode{
    self.selectionMode = YES;
    self.addSelectedButton.hidden = YES;
    self.selectButton.title = @"Done";
    [self.addSelectedButton setNeedsDisplay];
}

-(void)exitSelectionMode{
    self.selectionMode = NO;
    self.addSelectedButton.hidden = NO;
    self.selectButton.title = @"Select";
    [self.addSelectedButton setNeedsDisplay];
}

#pragma constants

const int IPHONE_WIDTH = 320;

#pragma delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    // Get the count of assets in the albumPhotos array
    NSInteger numCells = self.albumPhotos.count;
    NSLog(@"There are %d cells", numCells);
    return numCells;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumPhotoCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[AlbumCVC class]]) {
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        albumCVC.aView.imageView.image = [UIImage imageWithCGImage:[[self.albumPhotos[indexPath.item] asset]thumbnail]];
        if (self.albumPhotos[indexPath.item]) {
            albumCVC.assetObject = self.albumPhotos[indexPath.item];
        } else {
            NSLog(@"something wrong with albumPhotos array");
        }
    }
    return cell;
   
}



#pragma lifecycle methods

-(void)viewWillAppear:(BOOL)animated{
    
    //For debugging, just checking that all the URLs are unique
    for (int i=0; i<self.albumPhotos.count; i++) {
        AssetObject *object = self.albumPhotos[i];
        NSString *urlstring = [[object.asset valueForProperty:ALAssetPropertyAssetURL] absoluteString];
        NSLog(@"%@", urlstring);
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        self.bigImageDelegate = segue.destinationViewController;
        ALAssetRepresentation *thisRepresentation = [self.segueAsset defaultRepresentation];
        ALAssetOrientation orientation = [thisRepresentation orientation];

        UIImage *bigImage = [UIImage imageWithCGImage:[thisRepresentation fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)orientation];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:bigImage];
        self.bigImageDelegate.imageView = imageView;

        
    }
    
}




#pragma instantiation


//This array holds assetObjects, not ALAssets.
- (NSMutableArray *)albumPhotos{
    if (!_albumPhotos) {
        _albumPhotos = [[NSMutableArray alloc]init];
    }
    return _albumPhotos;
}

- (NSMutableSet *)assetObjectSet{
    if (!_assetObjectSet) {
        _assetObjectSet = [[NSMutableSet alloc]init];
    }
    return _assetObjectSet;
}


@end
