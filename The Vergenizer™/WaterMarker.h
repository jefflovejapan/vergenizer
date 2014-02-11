//
//  WaterMarker.h
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/10/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetObject.h"
#import "PhotoHandler.h"

@protocol WaterMarkerDelegate <NSObject>
-(void)finishedWatermarkingForAssetObject:(AssetObject *)ao;
@property(strong, nonatomic)PhotoHandler *handler;
@end

@interface WaterMarker : NSObject
-(WaterMarker *) initWithAssetObjects:(NSMutableArray *)assetObjects;
-(void)waterMarkPhotos;
@property id<WaterMarkerDelegate> delegate;

@end
