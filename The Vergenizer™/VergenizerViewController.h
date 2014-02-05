//
//  VergenizerViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 6/30/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//
//  This is the main view controller for The Vergenizer. 
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"
#import "PhotoHandler.h"
#import "VergenizerCVC.h"
#import "VDetailViewController.h"

@protocol DetailDelegate <NSObject>
@property (strong, nonatomic) AssetObject *assetObject;
@property (strong, nonatomic) NSMutableArray *assetObjects;
@end


@interface VergenizerViewController : UIViewController <VergenizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PhotoHandler *handler;
@property (strong, nonatomic) NSMutableArray *assetObjects;
@property (strong, nonatomic) id<DetailDelegate> detailDelegate;

-(void)addAssetObjects:(NSMutableArray *)objects;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) PickerViewController *picker;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *vergenizeButton;

@end

