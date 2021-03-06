//
//  vergenizerDetailViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetObject.h"
#import "VDetailView.h"
#import "DblTapZoomScrollView.h"
#import "DetailDelegate.h"

@interface VDetailViewController : UIViewController <DetailDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) AssetObject *assetObject;
@property (strong, nonatomic) NSMutableArray *assetObjects;

@property (weak, nonatomic) IBOutlet DblTapZoomScrollView *scrollView;
@property (strong, nonatomic) DetailView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *allSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *allSwitchState;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeControlOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *wmControlOutlet;
@property (strong, nonatomic) UIImageView *imageView;


@end
