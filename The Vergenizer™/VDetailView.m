//
//  DetailView.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 8/1/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailView.h"

@interface DetailView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *wmView;
@end

@implementation DetailView

#define WM_ALPHA 0.2
#define WM_RATIO 0.016

-(DetailView *)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

-(void)setup{
    [self addSubview:self.imageView];
    [self addSubview:self.wmView];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}


-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}

-(CGRect)getPhotoFrame{
    return self.imageView.frame;
}


-(CGSize)getImageSize{
    return self.imageView.image.size;
    
}

-(UIImageView *)wmView{
    if (!_wmView) {
        _wmView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    [_wmView setAlpha:WM_ALPHA];
    return _wmView;
}

-(void)setPhotoImage:(UIImage *)photoImage{
    self.imageView.image = photoImage;
    [self setFrame:self.imageView.frame];
    [self.imageView setFrame:self.frame];
}

-(void)setWmImage:(UIImage *)wmImage{
    self.wmView.image = wmImage;
    [self.wmView sizeToFit];
    [self setWmViewFrame];
    [self setNeedsDisplay];
}

-(void)setWmViewFrame{
    CGFloat wmOffset = self.imageView.frame.size.width * WM_RATIO;
    CGSize ivSize = self.imageView.frame.size;
    CGSize wmvSize = self.wmView.frame.size;
    CGRect wmRect = CGRectMake(ivSize.width - wmvSize.width - wmOffset, ivSize.height - wmvSize.height - wmOffset, wmvSize.width, wmvSize.height);
    [self.wmView setFrame:wmRect];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self.imageView setFrame:self.frame];
}

@end
