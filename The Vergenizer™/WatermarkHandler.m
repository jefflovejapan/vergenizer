//
//  WatermarkHandler.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "WatermarkHandler.h"
#import "AssetObject.h"

@implementation WatermarkHandler

- (NSMutableDictionary *)details{
    if (!_details) {
        _details = [[NSMutableDictionary alloc]init];
    }
    return _details;
}

- (void)addNewObjectWithAsset:(ALAsset *)asset{
    AssetObject *newObject = [[AssetObject alloc]initWithAsset:asset];
    NSString *URLString = [asset valueForProperty:ALAssetPropertyAssetURL];
    [self.details setObject:newObject forKey:URLString];
    NSLog(@"Just added a new object to dictionary inside wmHandler");
}

-(AssetObject *)assetObjectForURLString:(NSString *)URLString{
    AssetObject *returnObject = [self.details objectForKey:URLString];
    if (returnObject) {
        return returnObject;
    } else {
        [NSException raise:@"No object for key" format:@"You asked for an object at a key that doesn't exist in this handler's dictionary"];
        return nil;
    }
    
}

-(void)watermarkAssetObjectsInDictionary:(NSDictionary *)dictionary intoGroup:(ALAssetsGroup *)group{
//    NSArray *keys = [dictionary allKeys];
//    for (int i = 0; i<keys.count; i++) {
//        if (![[dictionary objectForKey:keys[i]] isKindOfClass:[AssetObject class]]) {
//            [NSException raise:@"Object isn't an Asset Object" format:@"Object in provided dictionary isn't of class AssetObject"];
//        } else {
//            ALAsset *asset = [dictionary objectForKey:keys[i]];
//            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
//            CGImageRef thisImage = [assetRep fullResolutionImage];
//            ALAssetOrientation assetOrientation = [assetRep orientation];
//            CGContextRef thisContext;
//            myLayerContext = CGLayerCreateWithContext(thisContext, thisImage.size, )
//
//            CGImageRef *cgRef = [assetRep CGImageWithOptions:@{]
//        }
//    }
}

@end
