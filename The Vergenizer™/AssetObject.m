//
//  AssetObject.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/25/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "AssetObject.h"

@implementation AssetObject

//
- (AssetObject *)initWithAsset:(ALAsset *)asset{
    self = [super init];
    NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
    self.assetURL = assetURL;
    self.URLString = [assetURL absoluteString];
    self.asset = asset;
    
#warning These should really be some kind of constant, but not sure how to implement
    self.watermarkColor = @"white";
    self.watermarkShape = @"logo";
    self.outputSize = 1020;
    self.checkmarkHidden = YES;
    return self;
}

#warning need to implement hash as well. Also, Zen makes the point that introspection and casting might not be the best way to go about this
- (BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        AssetObject *assetObject = (AssetObject *)object;
        NSLog(@"Inside isEqual \n self.URLString: %@ \n other.URLString: %@", self.URLString, assetObject.URLString);
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

//Any time we set either self.watermarkColor or self.watermarkShape we automatically set self.watermarkString
- (void)syncWatermarkString{
    NSLog(@"Just called syncWatermarkString inside assetObject \n watermarkShape is %@ \n watermarkColor is %@ \n outputSize is %d", self.watermarkShape, self.watermarkColor, self.outputSize);
    int watermarkSize = 0;
    if (!self.watermarkShape || !self.watermarkColor || !self.outputSize) {
        self.watermarkString = nil;
        NSLog(@"Just sent self.watermarkString = nil");
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
    NSLog(@"Just set self.watermarkString = %@", self.watermarkString);
    
}

@end
