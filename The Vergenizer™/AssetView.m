//
//  AssetView.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/25/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AssetView.h"

@interface AssetView ()

@end

@implementation AssetView


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

-(void)setup{
    self.imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:self.imageView];
    self.checkmarkView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"checkmark"]];
    [self addSubview:self.checkmarkView];
    self.checkmarkView.hidden = YES;
}

@end
