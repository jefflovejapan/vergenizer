//
//  PickerViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/6/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoHandler.h"
#import "AlbumViewController.h"
#import "AssetObject.h"

@protocol PhotoHandlerDelegate <NSObject>
@property (strong, nonatomic) PhotoHandler *handler;
@end


@interface PickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AlbumDelegate>
@property (weak, nonatomic) IBOutlet UITableView *albumTable;
@property (strong, nonatomic) id <PhotoHandlerDelegate> handlerDelegate;
@property (strong, nonatomic) PhotoHandler *handler;
@property (weak, nonatomic) AlbumViewController *albumController;
@end

