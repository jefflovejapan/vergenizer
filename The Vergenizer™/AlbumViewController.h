//
//  AlbumViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoHandler.h"

@protocol AlbumDelegate <NSObject>
@property (strong, nonatomic) PhotoHandler *handler;
@end

@protocol BigImageDelegate <NSObject>
@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@end

@protocol VergenizerDelegate <NSObject>
@property (strong, nonatomic) NSMutableOrderedSet *orderedURLSet;
-(void)addURLSet:(NSSet *)objects;
@end




@interface AlbumViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) id<BigImageDelegate> bigImageDelegate;
@property (strong, nonatomic) id<AlbumDelegate> albumDelegate;
@property (strong, nonatomic) id<VergenizerDelegate> vergenizerDelegate;

//outlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *selectButton;
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollectionView;
@property (weak, nonatomic) IBOutlet UIView *addSelectedButtonView;
@property (weak, nonatomic) IBOutlet UIButton *addSelectedButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@property (nonatomic) BOOL selectionMode;
@property (nonatomic) NSInteger albumIndex;
@property (nonatomic, strong) NSMutableArray *albumPhotos;
@property (nonatomic, strong) ALAssetsGroup *group;


@end
