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
- (void) addImageViewFromAsset{
    [self.aView insertSubview:[[UIImageView alloc]initWithFrame:self.aView.frame] atIndex:0];
    self.aView.imageView= self.aView.subviews[0];
    self.aView.imageView.image = [UIImage imageWithCGImage:[self.asset thumbnail]];
    [self setNeedsDisplay];
}

- (void) syncCheckmark{
    self.aView.checkmarkView.hidden = !self.checkmark;
    if (self.checkmark) {
        self.aView.imageView.alpha = 0.5;
    } else {
        self.aView.imageView.alpha = 1.0;
    }
    [self setNeedsDisplay];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
