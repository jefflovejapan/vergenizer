//
//  AlbumCVC.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetView.h"
#import "AssetObject.h"

@interface AlbumCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet AssetView *aView;

@property (weak, nonatomic) AssetObject *assetObject;


- (void)addImageFromAsset;
- (void)syncCheckmark;

@end
