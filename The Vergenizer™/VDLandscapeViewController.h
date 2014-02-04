//
//  VDLandscapeViewController.h
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/4/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "AssetObject.h"
#import "DblTapZoomScrollView.h"
#import "VergenizerViewController.h"
#import "VDetailView.h"

@interface VDLandscapeViewController : UIViewController<DetailDelegate, UIScrollViewDelegate>


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
