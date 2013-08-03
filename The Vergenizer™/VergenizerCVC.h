//
//  VergenizerCVC.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VergenizerImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface VergenizerCVC : UICollectionViewCell
@property (weak, nonatomic) IBOutlet VergenizerImageView *imageView;
@property (strong, nonatomic) ALAsset *asset;
-(void) syncImage;

@end
