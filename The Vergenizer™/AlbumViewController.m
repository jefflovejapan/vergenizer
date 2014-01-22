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

#define ALPHA_FOR_SELECTED 0.2
#define ALPHA_FOR_UNSELECTED 1
#define IPHONE_WIDTH 320


@interface AlbumViewController ()

//Used in segue to ImageViewController
@property (strong, nonatomic) UIImage *segueImage;
@property (nonatomic) NSInteger *someInt;
@property (strong, nonatomic) ImageViewController *ivc;

//Managing cell selections and the asset set to send back to VVC
@property (strong, nonatomic) NSMutableDictionary *selectedItems;
@property (strong, nonatomic) NSMutableOrderedSet *assetObjectSet;

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
    NSArray *controllers = [self.navigationController viewControllers];
    if ([controllers[0] conformsToProtocol:@protocol(VergenizerDelegate)]) {
        self.vergenizerDelegate = controllers[0];
        NSNumber *key;
        for (key in self.selectedItems.allKeys){
            NSLog(@"Value for %@: %@", key, self.selectedItems[key]);
            if ([self.selectedItems[key] boolValue]) {
                NSLog(@"bool val is true");
                if (self.albumImages[[key intValue]] == nil) {
                    NSLog(@"Nil image wtf");
                }
                AssetObject *ao = [[AssetObject alloc]initWithAsset:self.albumImages[[key intValue]]];
                [self.assetObjectSet addObject:ao];
                NSLog(@"The length of self.assetObjectSet is %d", self.assetObjectSet.count);
            } else {
                NSLog(@"Bool value is false");
            }
        };
        [self.vergenizerDelegate addAssetObjectSet:self.assetObjectSet];
    }
    NSLog(@"Popping to root");
    [self.navigationController popToRootViewControllerAnimated:YES];
}




#pragma Private Methods

-(CGFloat) alphaForSelected:(NSNumber *)selected{
    if ([selected boolValue]) {
        return ALPHA_FOR_SELECTED;
    } else {
        return ALPHA_FOR_UNSELECTED;
    }
}

-(void) goBig:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"bigImageSegue" sender:self];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.item];
    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop){
        if (result != nil) {
            [self setIVCAsset:result];
        }
    };
    [self.group enumerateAssetsAtIndexes:indexSet options:0 usingBlock:resultsBlock];
}

-(void)setIVCAsset:(ALAsset *)asset{
    if (self.ivc) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        ALAssetOrientation alo = [rep orientation];
        CGImageRef ref = [[asset defaultRepresentation]fullResolutionImage];
        UIImage *image = [UIImage imageWithCGImage:ref scale:1.0 orientation:(UIImageOrientation)alo];
        self.ivc.image = image;
        
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

#pragma delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    
    // Get the count of assets in the albumThumbnails array
    NSInteger numCells = self.albumImages.count;
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
    cell.alpha = [self alphaForSelected:self.selectedItems[@(indexPath.item)]];
    return cell;
}



#pragma lifecycle methods

-(void)viewWillAppear:(BOOL)animated{

    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        self.ivc = segue.destinationViewController;
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
