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
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            [self.groups addObject:group];
        }
    };
    
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        [NSException raise:@"Hit failure block insidePhotoHandler" format:@"Weren't able to get through enumerating groups in ALAssetLibrary"];
    };
    
    NSUInteger groupTypes = ALAssetsGroupAll;
    [self.library enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:failureBlock];
    
    return self;
}

- (void)addAssetGroupWithName:(NSString *)nameString{
    ALAssetsLibraryGroupResultBlock newGroupBlock = ^(ALAssetsGroup *group) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Vergenized group added");
#warning Need something here to let vvc know it can start watermarking
            });
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        [error localizedDescription];
    };
    
    [self.library addAssetsGroupAlbumWithName:nameString resultBlock:newGroupBlock failureBlock:failureBlock];
}


- (ALAssetsLibrary *) library{
    if (!_library) _library = [[ALAssetsLibrary alloc] init];
    return _library;
}

- (NSMutableArray *) groups{
    if (!_groups) _groups = [[NSMutableArray alloc]init];
    return _groups;
}

@end
