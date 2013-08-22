//
//  AlbumCVC.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/21/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AlbumCVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumCVC ()

@end

@implementation AlbumCVC

//Adds a new UIImageView subview at index 0 to the cell's AssetView subview.
- (void) addImageFromAsset{
    self.aView.imageView.image = [UIImage imageWithCGImage:[self.assetObject.asset thumbnail]];
    [self.aView setNeedsDisplay];
}

//Checkmark state is contained in the assetObject itself
- (void)syncCheckmark{
    self.aView.checkmarkView.hidden = self.assetObject.checkmarkHidden;
    self.aView.alpha = self.assetObject.checkmarkHidden ? 1.0:0.5;
    [self.aView setNeedsDisplay];
}


@end
