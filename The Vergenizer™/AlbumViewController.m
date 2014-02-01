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

- (NSUInteger)reverseAlbumIndexForIndex:(NSUInteger)index;

//Used in segue to ImageViewController
@property (strong, nonatomic) UIImage *segueImage;
@property (nonatomic) NSInteger *someInt;
@property (strong, nonatomic) ImageViewController *ivc;

//Managing cell selections and the asset set to send back to VVC
@property (strong, nonatomic) NSMutableDictionary *selectedItems;
@property (strong, nonatomic) NSMutableArray *assetObjects;

@property (nonatomic) BOOL selectionMode;

@end

@implementation AlbumViewController

#pragma Actions

- (IBAction)selectButtonTap:(id)sender {
    if (!self.selectionMode) {
        [self enterSelectionMode];
    } else {
        [self exitSelectionMode];
    }
}

- (IBAction)albumCellTap:(id)sender {
    NSLog(@"taptap");
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if ([cell isKindOfClass:[AlbumCVC class]]) {
            if (self.selectionMode) {
                [self toggleIndexSelection:indexPath];
            } else {
                [self goBig:indexPath.item];
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

- (IBAction)addSelectedButton:(id)sender {
    NSArray *controllers = [self.navigationController viewControllers];
    if ([controllers[0] conformsToProtocol:@protocol(VergenizerDelegate)]) {
        self.vergenizerDelegate = controllers[0];
        NSNumber *key;
        for (key in self.selectedItems.allKeys){
            if ([self.selectedItems[key] boolValue]) {
                AssetObject *ao = [[AssetObject alloc]initWithAsset:self.albumAssets[[self reverseAlbumIndexForIndex:[key intValue]]]];
                [self.assetObjects addObject:ao];
            }
        };
        [self.vergenizerDelegate addAssetObjects:self.assetObjects];
    }
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

-(void) goBig:(NSUInteger)index{
    [self performSegueWithIdentifier:@"bigImageSegue" sender:self];
    NSUInteger reverseIndex = [self reverseAlbumIndexForIndex:index];
    [self setIVCAsset:self.albumAssets[reverseIndex]];
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
    
    NSInteger numCells = self.albumAssets.count;
    return numCells;
}

//We want to return assets in reverse chronological order
- (NSUInteger)reverseAlbumIndexForIndex:(NSUInteger)index{
    return self.albumAssets.count - index - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumPhotoCell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[AlbumCVC class]]) {
        AlbumCVC *albumCVC = (AlbumCVC *)cell;
        albumCVC.albumImageView.image = [[UIImage alloc] initWithCGImage:[self.albumAssets[[self reverseAlbumIndexForIndex:indexPath.item]] thumbnail]];
    }
    cell.alpha = [self alphaForSelected:self.selectedItems[@(indexPath.item)]];
    return cell;
}



#pragma lifecycle methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        self.ivc = segue.destinationViewController;
    }
}


#pragma instantiation

-(NSMutableArray *)albumAssets{
    if (!_albumAssets) {
        _albumAssets = [[NSMutableArray alloc]init];
    }
    return _albumAssets;
}

-(NSMutableDictionary *)selectedItems{
    if (!_selectedItems) {
        _selectedItems = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < self.albumAssets.count; i++) {
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

-(NSMutableArray *) assetObjects {
    if (!_assetObjects) {
        _assetObjects = [[NSMutableArray alloc] init];
    }
    return _assetObjects;
}


@end
