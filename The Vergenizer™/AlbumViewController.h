//
//  AlbumViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoHandler.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageViewController.h"


@protocol VergenizerDelegate <NSObject>
@property (strong, nonatomic) NSMutableArray *assetObjects;
-(void)addAssetObjects:(NSMutableArray *)objects;
@end




@interface AlbumViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, IvcDelegate>
@property (strong, nonatomic) id<VergenizerDelegate> vergenizerDelegate;

//outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *addSelectedButton;

@property (nonatomic, strong) NSMutableArray *albumAssets;
@property (nonatomic, strong) ALAssetsGroup *group;
@property (nonatomic, strong) PhotoHandler *handler;
-(void) toggleIndexSelection:(NSIndexPath *) indexPath;

@end
