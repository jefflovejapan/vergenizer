//
//  vergenizerDetailViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VergenizerViewController.h"
#import "WatermarkHandler.h"
#import "AssetObject.h"
#import "VDetailView.h"

@interface vergenizerDetailViewController : UIViewController <DetailDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) AssetObject *assetObject;
//-(void)updateWM:(NSInteger)wmInt;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) DetailView *detailView;

@property (weak, nonatomic) IBOutlet UILabel *allSwitchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *allSwitchState;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sizeControlOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *wmControlOutlet;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) NSMutableOrderedSet *assetObjectSet;

@end
