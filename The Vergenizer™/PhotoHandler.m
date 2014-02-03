//
//  PhotoHandler.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/18/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "PhotoHandler.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoHandler ()
@property (strong, nonatomic) ALAsset *returnAsset;

@end

@implementation PhotoHandler


-(PhotoHandler *)init{
    self = [super init];
    [self.groups removeAllObjects];
    [self updateAssetGroups];
    return self;
}

-(void)updateAssetGroups{
    void (^listGroupBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            if (![self.groups containsObject:group]) {
                [self.groups addObject:group];
            }
        }
    };
    
    void (^failureBlock)(NSError *) = ^(NSError *error) {
        [NSException raise:@"Hit failure block insidePhotoHandler" format:@"%@", [error description]];
    };
    
    NSUInteger groupTypes = ALAssetsGroupAll;
    [self.library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
}


- (ALAssetsLibrary *) library{
    if (!_library) {
     _library = [[ALAssetsLibrary alloc] init];   
    }
    return _library;
}

- (NSMutableArray *) groups{
    if (!_groups) _groups = [[NSMutableArray alloc]init];
    return _groups;
}

@end
