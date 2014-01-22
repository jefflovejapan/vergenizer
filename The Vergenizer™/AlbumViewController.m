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
@property (strong, nonatomic) UIImage *segueImage;
@property (nonatomic) NSInteger *someInt;
@property (strong, nonatomic) ImageViewController *ivc;

//Used rather than array to check for dupes. Gets new photos unioned into set via 
@property (strong, nonatomic) NSMutableDictionary *selectedItems;

//Are we in selectionMode?
@property (nonatomic) BOOL selectionMode;

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


#warning Need to add selected photos to array

- (IBAction)albumCellTap:(id)sender {
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[AlbumCVC class]]) {
            if (self.selectionMode) {
                [self toggleIndexSelection:indexPath];
            } else {
                [self goBig:indexPath];
            }
        }
    }
}


-(void)toggleIndexSelection:(NSIndexPath *)indexPath {
    NSNumber *selection = @(indexPath.item);
    NSNumber *newValue = @(![self.selectedItems[selection] boolValue]);
    self.selectedItems[selection] = newValue;
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}



//Needs to be implemented. Take an array/set of selected assets and send them back to VergenizerViewController for watermarking.
- (IBAction)addSelectedButton:(id)sender {
//    NSArray *controllers = [self.navigationController viewControllers];
//    if ([controllers[0] conformsToProtocol:@protocol(VergenizerDelegate)]) {
//        self.vergenizerDelegate = controllers[0];
//        [self.vergenizerDelegate addAssetObjectSet:self.assetObjectSet];
//        NSLog(@"The length of self.assetObjectSet is %d", self.assetObjectSet.count);
//    }
//    NSLog(@"Popping to root");
//    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma Private Methods

-(void) goBig:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"bigImageSegue" sender:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.item];
#warning Need to figure out why setIVCViewsWithAsset is getting called twice
    //    for (int i = 0; i<indexSet.count; i++) {
//        NSLog(@"item %d in indexSet is %d", i, indexSet[i]);
//    }
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        NSLog(@"Calling setIVCViews");
        [self setIVCViewsWithAsset:result];
    };
    [self.group enumerateAssetsAtIndexes:indexSet options:0 usingBlock:resultsBlock];
}

-(void)setIVCViewsWithAsset:(ALAsset *)asset{
    if (self.ivc) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        ALAssetOrientation alo = [rep orientation];
        CGImageRef ref = [[asset defaultRepresentation]fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:ref scale:1.0 orientation:(UIImageOrientation)alo];
        NSLog(@"UIImage is %f by %f", image.size.width, image.size.height);
        self.ivc.scrollView.contentSize = image.size;
        NSLog(@"Scroll View is %f by %f", self.ivc.scrollView.contentSize.width, self.ivc.scrollView.contentSize.height);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        self.ivc.imageView = imageView;
        [self.ivc.scrollView addSubview:self.ivc.imageView];
        [self.ivc.scrollView setMinimumZoomScale:0.1];
        [self.ivc.scrollView setMaximumZoomScale:1.0];
        [self.ivc.scrollView zoomToRect:self.ivc.imageView.bounds animated:NO];
        [self.ivc.scrollView setNeedsDisplay];
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
    
    // Get the count of assets in the albumThumbnails array
    NSInteger numCells = self.albumImages.count;
    NSLog(@"There are %d cells", numCells);
    return numCells;
    
}

//Way simpler. The trick to getting back to ALAssets is going to be the index paths of the highlighted cells. We can put all those indexPaths in a set and call enumerateWithIndexPaths on our ALAssetsGroup to get the assets.
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumPhotoCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[AlbumCVC class]]) {
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        albumCVC.albumImageView.image = self.albumImages[indexPath.item];
    }
    return cell;
}



#pragma lifecycle methods

-(void)viewWillAppear:(BOOL)animated{

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        self.ivc = segue.destinationViewController;
//What's happening? I tap a cell then kick off a block to find the alasset AND segue. No way to know which one returns first.
//Choice 1: I segue right away with a 0,0 image. From the segue I get the destination view controller, which I can keep in a property. That way my enumeration block can see it and know how to set up the scroll view.
//Choice 2: I kick off the enumeration block first. That way I'm sure to have the image when I hit the segue. Problem is I would need to block the main thread.
    }
}


#pragma instantiation


//This array holds UIImages. It's going to be set on segue in so that we'll already have an array of images to draw from for collectionViewCells.
-(NSMutableArray *)albumImages{
    if (!_albumImages) {
        _albumImages = [[NSMutableArray alloc]init];
    }
    return _albumImages;
}

-(NSMutableDictionary *)selectedItems{
    if (!_selectedItems) {
        _selectedItems = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < self.albumImages.count; i++) {
            _selectedItems[[NSNumber numberWithInt:i]] = @NO;
        }
    }
    return _selectedItems;
}

-(ImageViewController *)ivc{
    if (!_ivc) {
        _ivc = [[ImageViewController alloc]init];
    }
    return _ivc;
}


@end
