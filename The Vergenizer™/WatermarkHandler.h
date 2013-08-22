//
//  WatermarkHandler.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetObject.h"

@interface WatermarkHandler : NSObject

//Need a mutable dictionary of images and their watermark details: sizes, watermarks
@property (strong, nonatomic) NSMutableDictionary *details;
- (void)addNewObjectWithAsset:(ALAsset *)asset;
-(AssetObject *)assetObjectForURLString:(NSString *)URLString;
-(void)watermarkAssetObjectsInDictionary:(NSDictionary *)dictionary intoGroup:(ALAssetsGroup *)group;

@end
