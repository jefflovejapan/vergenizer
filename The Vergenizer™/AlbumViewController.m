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
@property (strong, nonatomic) NSMutableSet *assetSet;

//Are we in selectionMode?
@property (nonatomic) BOOL selectionMode;

@end

@implementation AlbumViewController

#pragma Actions

//Gets triggered when tapping the "select" button. Should probably rename.
- (IBAction)selectButtonTap:(id)sender {
    NSLog(@"select button");
    if (!self.selectionMode) {
        [self enterSelectionMode];
    } else {
        
        [self exitSelectionMode];
    }
}


#warning Want to change this so that if selectionMode == YES we select and highlight the cell using UICollectionView's built-in mechanism. See: http://d.pr/AvIc

- (IBAction)albumCellTap:(id)sender {
    NSLog(@"taptap");
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[AlbumCVC class]]) {
            [self goBig:indexPath];
        }
    }
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
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        [self setIVCViewsWithAsset:result];
    };
    [self.group enumerateAssetsAtIndexes:indexSet options:0 usingBlock:resultsBlock];
}

-(void)setIVCViewsWithAsset:(ALAsset *)asset{
    
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
    NSLog(@"There are %d images in self.albumImages", self.albumImages.count);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Inside PFS in AVC");
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

-(NSMutableSet *)assetSet{
    if (!_assetSet) {
        _assetSet = [[NSMutableSet alloc]init];
    }
    return _assetSet;
}
-(ImageViewController *)ivc{
    if (!_ivc) {
        _ivc = [[ImageViewController alloc]init];
    }
    return _ivc;
}


@end
