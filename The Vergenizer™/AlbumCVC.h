//
//  AlbumCVC.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetView.h"

@interface AlbumCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet AssetView *aView;

@property (strong, nonatomic) ALAsset *asset;
@property (nonatomic) BOOL checkmark;

- (void) addImageViewFromAsset;
- (void) syncCheckmark;

@end
