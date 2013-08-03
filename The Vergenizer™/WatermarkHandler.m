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

- (void)addNewObjectWithString:(NSString *)URLString andAsset:(ALAsset *)asset{
    AssetObject *newObject = [[AssetObject alloc]initWithURLString:URLString andAsset:asset];
    [self.details setObject:newObject forKey:URLString];
    NSLog(@"Just added a new object to dictionary inside wmHandler");
}

-(AssetObject *)assetObjectForString:(NSString *)URLString{
    AssetObject *returnObject = [self.details objectForKey:URLString];
    if (returnObject) {
        return returnObject;
    } else {
        [NSException raise:@"No object for key" format:@"You asked for an object at a key that doesn't exist in this handler's dictionary"];
        return nil;
    }
    
}

@end
