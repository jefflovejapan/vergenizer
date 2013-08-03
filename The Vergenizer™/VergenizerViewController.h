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
@property (strong, nonatomic) ALAsset *asset;
@property (strong, nonatomic) WatermarkHandler *handler;
-(void) updateWM:(NSInteger)wmInt;
@end

@protocol WatermarkHandlerDelegate <NSObject>
@property (strong, nonatomic) WatermarkHandler *wmHandler;
@end

@interface VergenizerViewController : UIViewController <PhotoHandlerDelegate, AlbumDelegate, VergenizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, AssetBlockDelegate>

//properties declared in protocols
@property (strong, nonatomic) PhotoHandler *handler;
@property (strong, nonatomic) NSMutableOrderedSet *orderedURLSet;
@property (strong, nonatomic) id<DetailDelegate> detailDelegate;

-(void)addURLSet:(NSSet *)objects;
-(void)reloadNextIndexPathWithAsset:(ALAsset*)asset;

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) PickerViewController *picker;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *groups;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) WatermarkHandler *wmHandler;

@end

