//
//  ImageViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/27/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DblTapZoomScrollView.h"

@protocol IvcDelegate <NSObject>
-(void)toggleCurrentSelection;
-(NSNumber *)currentSelectionState;
@end

@interface ImageViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet DblTapZoomScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) id<IvcDelegate> delegate;
@end
