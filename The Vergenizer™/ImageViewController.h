//
//  ImageViewController.h
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/27/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DblTapZoomScrollView.h"

@interface ImageViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet DblTapZoomScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;
@end
