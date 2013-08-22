//
//  VergenizerCVC.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerCVC.h"

@implementation VergenizerCVC

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) syncImage{
    self.imageView.image = [UIImage imageWithCGImage:[self.assetObject.asset thumbnail]];
}

@end
