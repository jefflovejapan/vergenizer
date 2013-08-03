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
@property (strong, nonatomic) NSMutableSet *URLSet;
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
        self.VergenizerDelegate = controllers[0];
        [self.vergenizerDelegate addURLSet:self.URLSet];
    }
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
        self.segueAsset = albumCVC.asset;
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
    if ([cell isKindOfClass:[AlbumCVC class]]) {
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        if (albumCVC) {
            BOOL thisCheckmark = albumCVC.checkmark;
            
            //Can't compare isEqual with ALAssets, so use URLs instead
            NSURL *assetURL = [albumCVC.asset valueForProperty:ALAssetPropertyAssetURL];
            
            //If checkmark is set to NO in the albumCVC
            if (!thisCheckmark) {
                //A tap means we should add this asset to our URLSet
                [self.URLSet addObject:assetURL];
                albumCVC.checkmark = YES;
                [albumCVC syncCheckmark];
            } else if(thisCheckmark) {
                [self.URLSet removeObject:assetURL];
                albumCVC.checkmark = NO;
                [albumCVC syncCheckmark];
            }
            self.countLabel.text = [NSString stringWithFormat:@"%d", self.URLSet.count];
            [self.countLabel setNeedsDisplay];
        }
    }
    
}

-(void)enterSelectionMode{
    self.selectionMode = YES;
    self.addSelectedButtonView.hidden = YES;
    self.selectButton.title = @"Done";
    [self.addSelectedButtonView setNeedsDisplay];
}

-(void)exitSelectionMode{
    self.selectionMode = NO;
    self.addSelectedButtonView.hidden = NO;
    self.selectButton.title = @"Select";
    [self.addSelectedButtonView setNeedsDisplay];
}

#pragma constants

const int IPHONE_WIDTH = 320;

#pragma delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    // Get the count of photos in album at index albumIndex in the PhotoHandler
    NSInteger numCells = [self.group numberOfAssets];
    return numCells;
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumPhotoCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[AlbumCVC class]]){
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        ALAsset *thisImage = [self.albumPhotos objectAtIndex:indexPath.item];
        
        albumCVC.asset = thisImage;
        
        // Adding a subview to the cell - create a new UIImageView from the thumbnail of thisImage
        [albumCVC addImageViewFromAsset];
    }
    
    return cell;
}


#pragma lifecycle methods

- (void)viewWillAppear:(BOOL)animated{
    [self.albumPhotos removeAllObjects];
    self.group = self.albumDelegate.handler.groups[self.albumIndex];
    [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            ALAsset *asset = [[ALAsset alloc]init];
            asset = result;
            [self.albumPhotos addObject:asset];
        }
    }];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        self.bigImageDelegate = segue.destinationViewController;
        ALAssetRepresentation *thisRepresentation = [self.segueAsset defaultRepresentation];
        ALAssetOrientation orientation = [thisRepresentation orientation];

        UIImage *bigImage = [UIImage imageWithCGImage:[thisRepresentation fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)orientation];
        NSLog(@"bigImage is %f by %f", bigImage.size.width, bigImage.size.height);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:bigImage];
        self.bigImageDelegate.imageView = imageView;

        
    }
    
}




#pragma instantiation

- (ALAssetsGroup *)group{
    if (!_group) {
        _group = [[ALAssetsGroup alloc]init];
    }
    return _group;
}

- (NSMutableArray *)albumPhotos{
    if (!_albumPhotos) {
        _albumPhotos = [[NSMutableArray alloc]init];
    }
    return _albumPhotos;
}

- (NSMutableSet *)URLSet{
    if (!_URLSet) {
        _URLSet = [[NSMutableSet alloc]init];
    }
    return _URLSet;
}


@end
