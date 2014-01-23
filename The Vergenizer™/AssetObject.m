//
//  AssetObject.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/25/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AssetObject.h"

#define DEFAULT_WM_COLOR @"white"
#define DEFAULT_WM_SHAPE @"logo"
#define DEFAULT_WM_SIZE 1020

@implementation AssetObject

//
- (AssetObject *)initWithAsset:(ALAsset *)asset{
    self = [super init];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    self.assetURL = assetURL;
    self.URLString = [assetURL absoluteString];
    self.asset = asset;
    
    self.watermarkColor = DEFAULT_WM_COLOR;
    self.watermarkShape = DEFAULT_WM_SHAPE;
    self.outputSize = DEFAULT_WM_SIZE;
    return self;
}

- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        AssetObject *assetObject = (AssetObject *)object;
        if ([self.URLString isEqualToString:assetObject.URLString]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        NSLog(@"Inside isEqual and classes aren't equal");
        return [super isEqual:object];
    }
}

- (void)setWatermarkColor:(NSString *)watermarkColor{
    _watermarkColor = watermarkColor;
    [self syncWatermarkString];
}

- (void)setWatermarkShape:(NSString *)watermarkShape{
    _watermarkShape = watermarkShape;
    [self syncWatermarkString];
}

- (void)setOutputSize:(NSInteger)outputSize{
    _outputSize = outputSize;
    [self syncWatermarkString];
}

- (void)syncWatermarkString{
    int watermarkSize = 0;
    if (!self.watermarkShape || !self.watermarkColor || !self.outputSize) {
        self.watermarkString = nil;
        return;
    } else if ([self.watermarkShape isEqualToString:@"logo"]) {
        if (self.outputSize == 560) {
            watermarkSize = 137;
        } else if (self.outputSize == 640){
            watermarkSize = 157;
        } else if (self.outputSize == 1020){
            watermarkSize = 250;
        } else if (self.outputSize == 2040){
            watermarkSize = 500;
        }
    } else if ([self.watermarkShape isEqualToString:@"triangle"]){
        if (self.outputSize == 560) {
            watermarkSize = 55;
        } else if (self.outputSize == 640){
            watermarkSize = 63;
        } else if (self.outputSize == 1020){
            watermarkSize = 100;
        } else if (self.outputSize == 2040){
            watermarkSize = 200;
    }
}
    self.watermarkString = [NSString stringWithFormat:@"%@_%@_%d", self.watermarkShape, self.watermarkColor, watermarkSize];
}

@end
