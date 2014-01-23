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
#import "AlbumViewController.h"
#import "VergenizerCVC.h"
#import "WatermarkHandler.h"

@protocol DetailDelegate <NSObject>
@property (strong, nonatomic) AssetObject *assetObject;
@property (weak, nonatomic) NSMutableOrderedSet *assetObjectSet;
@end

@protocol WatermarkHandlerDelegate <NSObject>
@property (strong, nonatomic) WatermarkHandler *wmHandler;
@end

@interface VergenizerViewController : UIViewController <VergenizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) PhotoHandler *handler;
@property (strong, nonatomic) NSMutableOrderedSet *assetObjectSet;
@property (strong, nonatomic) id<DetailDelegate> detailDelegate;

-(void)addAssetObjectSet:(NSMutableSet *)objects;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) PickerViewController *picker;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *vergenizeButton;


@property (strong, nonatomic) WatermarkHandler *wmHandler;

@end

