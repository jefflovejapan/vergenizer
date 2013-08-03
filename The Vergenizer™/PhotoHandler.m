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
@property (strong, nonatomic) ALAssetsLibrary *library;
@property (strong, nonatomic) ALAsset *returnAsset;

@end

@implementation PhotoHandler

- (void)assetForURL:(NSURL *)assetURL{
    
    //throwing the __block in front of this declaration lets the blocks below write to the object
//    __block ALAsset* derpAsset;
    
    ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset *asset){
        if (asset){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.returnAsset =  asset; //Should I be returning here? If so, why am I getting an error here? "Incompatible block pointer types passing 'ALAsset *(^)(void)' to parameter of type 'dispatch_block_t' (aka 'void (^)(void)')"
                if (self.returnAsset) {
                    NSLog(@"relax, returnassetexists");
                }
                [self.assetBlockDelegate reloadNextIndexPathWithAsset:self.returnAsset];
            });
        }
    };
    
    //Not hitting failure block
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error){
        NSLog(@"Cannot get image - %@", [error localizedDescription]);
    };
        
    //Here's the real ALAssetsLibrary method that I'm calling
    [self.library assetForURL:assetURL resultBlock:resultBlock failureBlock:failureBlock];
    
}

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
        
        //        else {
        //            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        //        }
    };
    
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
        //        AssetsDataIsInaccessibleViewController *assetsDataInaccessibleViewController = [[AssetsDataIsInaccessibleViewController alloc] initWithNibName:@"AssetsDataIsInaccessibleViewController" bundle:nil];
        //
        //        NSString *errorMessage = nil;
        //        switch ([error code]) {
        //            case ALAssetsLibraryAccessUserDeniedError:
        //            case ALAssetsLibraryAccessGloballyDeniedError:
        //                errorMessage = @"The user has declined access to it.";
        //                break;
        //            default:
        //                errorMessage = @"Reason unknown.";
        //                break;
        NSLog(@"Error in enumeration block.");
    };
    
    //        assetsDataInaccessibleViewController.explanation = errorMessage;
    //        [self presentModalViewController:assetsDataInaccessibleViewController animated:NO];
    //        [assetsDataInaccessibleViewController release];
    //    };
    
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
