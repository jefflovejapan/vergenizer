//
//  DetailDelegate.h
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/4/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DetailDelegate <NSObject>
@property (strong, nonatomic) AssetObject *assetObject;
@property (strong, nonatomic) NSMutableArray *assetObjects;
@end
