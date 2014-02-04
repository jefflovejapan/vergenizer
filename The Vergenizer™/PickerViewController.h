//
//  PickerViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/6/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoHandler.h"
#import "AlbumViewController.h"


@interface PickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *albumTable;
@property (strong, nonatomic) PhotoHandler *handler;
@end

