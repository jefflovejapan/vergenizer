//
//  PhotoHandler.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/18/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PhotoHandler : NSObject
@property (strong, nonatomic)NSMutableArray *groups;
@property (strong, nonatomic) ALAssetsLibrary *library;
@end
