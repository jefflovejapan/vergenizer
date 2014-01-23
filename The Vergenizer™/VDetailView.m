//
//  DetailView.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 8/1/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailView.h"

@implementation DetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}

-(UIImageView *)wmView{
    if (!_wmView) {
        _wmView = [[UIImageView alloc]init];
    }
    return _wmView;
}

@end
