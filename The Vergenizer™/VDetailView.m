//
//  DetailView.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 8/1/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailView.h"

@implementation DetailView

#define WM_ALPHA 0.2
#define WM_RATIO 0.016

-(DetailView *)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self addSubview:self.imageView];
        [self addSubview:self.wmView];
    }
    return self;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}

-(UIImageView *)wmView{
    if (!_wmView) {
        _wmView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    [_wmView setAlpha:WM_ALPHA];
    return _wmView;
}

-(void)setPhotoImage:(UIImage *)photoImage{
    NSLog(@"inside setPhotoImage");
    self.imageView.image = photoImage;
    [self.imageView sizeToFit];
}

-(void)setWmImage:(UIImage *)wmImage{
    NSLog(@"inside setwmimage");
    NSLog(@"%@", self.subviews);
    self.wmView.image = wmImage;
    [self.wmView sizeToFit];
    [self setWmViewFrame];
    [self setNeedsDisplay];
}

-(void)setWmViewFrame{
    NSLog(@"inside setwmviewframe");
    CGFloat wmOffset = self.imageView.frame.size.width * WM_RATIO;
    CGRect wmRect = CGRectMake(self.imageView.frame.size.width - self.wmView.frame.size.width - wmOffset, self.imageView.frame.size.height - self.wmView.frame.size.height - wmOffset, self.wmView.frame.size.width, self.wmView.frame.size.height);
    [self.wmView setFrame:wmRect];
    NSLog(@"%@", self.subviews);
}

@end
