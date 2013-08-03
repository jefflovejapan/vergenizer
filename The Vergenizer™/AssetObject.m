//
//  AssetObject.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/25/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AssetObject.h"

@implementation AssetObject

- (AssetObject *)initWithURLString:(NSString *)URLString andAsset:(ALAsset *)asset{
    self = [super init];
    self.URLString = URLString;
    self.asset = asset;
    
#warning These should really be some kind of constant, but not sure how to implement
    self.watermarkString = [NSString stringWithFormat:@"verge_water_500_white"];
    self.watermarkSize = 1020;
    
    return self;
}

@end
