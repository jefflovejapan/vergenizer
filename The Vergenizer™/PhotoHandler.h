//
//  PhotoHandler.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/18/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//
//  Manages the app's ALAssetsLibrary, providing an interface to get at the groups, save files to a new group, etc. Also acts as table view data source
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol AssetBlockDelegate <NSObject>
-(void)reloadNextIndexPathWithAsset:(ALAsset*)asset;
@end

@interface PhotoHandler : NSObject
@property (strong, nonatomic)NSMutableArray *groups;
@property (strong, nonatomic) id<AssetBlockDelegate> assetBlockDelegate;
- (PhotoHandler *)init;
- (CGImageRef)posterImageForAssetsGroup:(ALAssetsGroup *)assetsGroup;
- (void)assetForURL:(NSURL *)assetURL;
- (void)addAssetGroupWithName:(NSString *)nameString;
@end
