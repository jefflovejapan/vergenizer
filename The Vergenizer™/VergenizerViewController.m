//
//  VergenizerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 6/30/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerViewController.h"
#import "AssetObject.h"
#import "VDetailViewController.h"

#define OFFSET_RATIO 0.016
#define WM_ALPHA 0.2


@interface VergenizerViewController ()
@property (strong, nonatomic) AssetObject *detailAssetObject;
@property (strong, nonatomic) VDetailViewController *detailController;
@property (strong, nonatomic) id<DetailDelegate> detailDelegate;
@property (strong, nonatomic) NSMutableArray *toolbarButtons;
@property (strong, nonatomic) WaterMarker *waterMarker;
@end

@implementation VergenizerViewController

#pragma actions

- (IBAction)vergenizerCellTap:(id)sender {
    CGPoint tapLocation = [sender locationInView:self.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell && [cell isKindOfClass:[VergenizerCVC class]]) {
            VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
            self.detailAssetObject = vergenizerCVC.assetObject;
        }
        [self pushDetailView];
    }
}

-(void)finishedWatermarkingForAssetObject:(AssetObject *)ao{
    [self updateCollectionViewForAssetObject:ao];
}

- (IBAction)clearButton:(id)sender {
    [self.assetObjects removeAllObjects];
    [self.collectionView reloadData];
    [self clearNavPrompt];
    [self checkHiddenVergenizeButton];
}

- (IBAction)vergenizeButton:(id)sender {
    [self clearNavPrompt];
    [self.waterMarker waterMarkPhotos];
}

-(void)pushDetailView{
    self.detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailController"];
    if ([self.detailController conformsToProtocol:@protocol(DetailDelegate)]) {
        self.detailDelegate = (id)self.detailController;
        self.detailDelegate.assetObject = self.detailAssetObject;
        self.detailDelegate.assetObjects = self.assetObjects;
    }
    [self hideToolbar];
    [self hideNavBar];
    CATransition* transition = [self getPushAnimation];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:self.detailController animated:YES];
}

-(CATransition *)getPushAnimation{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.startProgress = 0.1;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom;
    //kCATransitionFromTop//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    return transition;
}


#pragma delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numCells = self.assetObjects.count;
    return numCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vergenizerCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[VergenizerCVC class]]) {
        VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
        AssetObject *assetObject = self.assetObjects[indexPath.item];
        vergenizerCVC.assetObject = assetObject;
        [vergenizerCVC syncImage];
    }
    return cell;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.collectionView layoutIfNeeded];
}


#pragma helper methods

-(void)addAssetObjects:(NSMutableArray *)objects{
    [self.assetObjects addObjectsFromArray:objects];
}


-(void)updateCollectionViewForAssetObject:(AssetObject *)ao{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *removePath = [NSIndexPath indexPathForItem:0 inSection:0];
        NSArray *removePathArray = [NSArray arrayWithObject:removePath];
        if (ao != nil) {
            [self.assetObjects removeObject:ao];
            [self.collectionView deleteItemsAtIndexPaths:removePathArray];
            [self checkHiddenVergenizeButton];
        }
    });
}


- (void)checkHiddenVergenizeButton{
    if (self.assetObjects.count == 0) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    } else {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)clearNavPrompt{
    self.navigationItem.prompt = nil;
}

-(void)hideToolbar{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)hideNavBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


#pragma lifecycle methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        [self clearNavPrompt];  // Animation screws up otherwise
        PickerViewController *pvc;
        pvc = segue.destinationViewController;
        pvc.handler = self.handler;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [self checkHiddenNavController];
    [self checkHiddenVergenizeButton];
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

-(void)checkHiddenNavController{
    if (self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.assetObjects.count == 0){
        self.navigationItem.prompt = nil;
    } else {
        self.navigationItem.prompt = @"Tap photos to edit";
    }
}

-(void)viewDidLoad{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController setToolbarHidden:YES animated:NO];
    self.waterMarker.delegate = self;
}

#pragma instantiation

- (NSMutableArray *)assetObjects{
    if (!_assetObjects) {
        _assetObjects = [[NSMutableArray alloc]init];
    }
    return _assetObjects;
}

- (PhotoHandler *)handler{
    if (!_handler) {
        _handler = [[PhotoHandler alloc]init];
    }
    return _handler;
}

-(WaterMarker *)waterMarker{
    if (!_waterMarker) {
        _waterMarker = [[WaterMarker alloc]initWithAssetObjects:self.assetObjects];
    }
    return _waterMarker;
}


@end