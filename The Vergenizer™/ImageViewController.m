//
//  ImageViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/27/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "ImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ImageViewController ()

@end

@implementation ImageViewController

#define MAX_ZOOM_SCALE 2.0
#define MIN_ZOOM_SCALE 0.1

- (void)viewWillAppear:(BOOL)animated{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _imageView;
}

- (void)viewDidLoad{
    [self.scrollView addSubview:self.imageView];
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    [self resetImage];
}

- (void)resetImage{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        if (self.image) {
            self.imageView.image = self.image;
            self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = self.image.size;
            [self.scrollView zoomToRect:self.imageView.bounds animated:NO];
            [self.scrollView setNeedsDisplay];
        }
    }
}

@end
