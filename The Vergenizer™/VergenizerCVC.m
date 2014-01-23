//
//  VergenizerCVC.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerCVC.h"

@implementation VergenizerCVC


-(void) syncImage{
    self.imageView.image = [UIImage imageWithCGImage:[self.assetObject.asset thumbnail]];
}

@end
