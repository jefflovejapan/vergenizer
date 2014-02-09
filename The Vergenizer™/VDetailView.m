//
//  DetailView.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 8/1/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailView.h"

@implementation DetailView

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
    return _wmView;
}

-(void)setPhotoImage:(UIImage *)photoImage{
    self.imageView.image = photoImage;
    [self.imageView sizeToFit];
}

-(void)setWmImage:(UIImage *)wmImage{
    self.wmView.image = wmImage;
    
    
}

@end
