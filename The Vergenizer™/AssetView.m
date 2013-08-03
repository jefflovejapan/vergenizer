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


// Using awakeFromNib because initWithFrame doesn't get called when initing from storyboard


-(void)awakeFromNib
{
    UIImage *checkmark = [UIImage imageNamed:@"Checkmark"];
    self.checkmarkView = [[UIImageView alloc]initWithImage:checkmark];
    [self addSubview:self.checkmarkView];
    self.checkmarkView.hidden = YES;
    
}


@end
