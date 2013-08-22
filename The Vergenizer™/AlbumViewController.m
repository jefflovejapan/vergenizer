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

//Used rather than array to check for dupes. Gets new photos unioned into set via 
@property (strong, nonatomic) NSMutableSet *assetSet;




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
- (IBAction)albumCellTap:(id)sender {
    self.someInt+=1;
    NSLog(@"tap tap %d", (int)self.someInt);
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

-(void) goBig:(UIImage *)image{
    self.segueImage = image;
    [self performSegueWithIdentifier:@"bigImageSegue" sender:self];
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
        albumCVC.imageView.image = self.albumImages[indexPath.item];
    }
    return cell;
}



#pragma lifecycle methods

-(void)viewWillAppear:(BOOL)animated{
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Inside PFS in AVC");
    if ([segue.identifier isEqualToString:@"bigImageSegue"]) {
        ImageViewController *ivc;
        ivc = segue.destinationViewController;
        UIImageView *imageView = [[UIImageView alloc]initWithImage:self.segueImage];
        ivc.imageView = imageView;
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

-(NSInteger *)someInt{
    if (!_someInt) {
        _someInt = 0;
    }
    return _someInt;
}

@end
