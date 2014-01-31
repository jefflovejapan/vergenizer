//
//  AssetObject.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/25/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef NS_ENUM(NSInteger, WatermarkTypes) {
    None                = 0,
    WhiteLogo           = 1,
    BlackLogo           = 2,
    WhiteTriangle       = 3,
    BlackTriangle       = 4
};

@interface AssetObject : NSObject
@property (nonatomic) NSString *URLString;
@property (strong, nonatomic) NSURL *assetURL;
@property (nonatomic) NSInteger outputSize;
@property (strong, nonatomic) NSString *watermarkShape;
@property (strong, nonatomic) NSString *watermarkColor;
@property (nonatomic) NSString *watermarkString;
@property (strong, nonatomic) ALAsset *asset;
- (AssetObject *)initWithAsset:(ALAsset *)asset;
-(void)setParamsFromAssetObject:(AssetObject *)ao;
- (BOOL)isEqual:(id)object;
@end
