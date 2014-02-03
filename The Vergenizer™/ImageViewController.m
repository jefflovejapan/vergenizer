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

#define MAX_ZOOM_SCALE 1.0
#define MIN_ZOOM_SCALE 0.1

#pragma lifecycle

- (void)viewDidLoad{
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    [self.scrollView setUserInteractionEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [self resetImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.scrollView zoomToRect:self.imageView.bounds animated:YES];
}

#pragma helper methods

- (void)resetImage{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        if (self.image) {
            self.imageView.image = self.image;
            self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
            self.scrollView.contentSize = self.image.size;
            CGRect zoomRect = CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
            [self.scrollView zoomToRect:zoomRect animated:NO];
        }
    }
}

#pragma instantiation

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

@end
