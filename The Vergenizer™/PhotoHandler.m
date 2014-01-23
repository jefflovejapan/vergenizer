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


- (CGImageRef)posterImageForAssetsGroup:(ALAssetsGroup *)assetsGroup{
    CGImageRef posterImage;
    posterImage = assetsGroup.posterImage;
    return posterImage;
}

-(PhotoHandler *)init{
    self = [super init];
    [self.groups removeAllObjects];
    [self updateAssetGroups];
    return self;
}

-(void)updateAssetGroups{
    NSLog(@"Inside UAG");
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            NSLog(@"self.groups contains %@: %d", group, [self.groups containsObject:group]);
            if (![self.groups containsObject:group]) {
                NSLog(@"Adding group %@", group);
                [self.groups addObject:group];
            }
        }
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
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
