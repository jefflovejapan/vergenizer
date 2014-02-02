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

#pragma actions


//- (IBAction)zoomDoubleTap:(id)sender {
//    CGPoint tapLocation = [sender locationInView:[self viewForZoomingInScrollView:self.scrollView]];
//    if (self.scrollView.zoomScale < self.scrollView.maximumZoomScale) {
//        CGSize currentRectSize = self.scrollView.bounds.size;
//        CGRect zoomRect = CGRectMake(tapLocation.x - (currentRectSize.width / 2.0), tapLocation.y - (currentRectSize.height / 2.0), (currentRectSize.width / 2.0), (currentRectSize.height / 2.0));
//        [self.scrollView zoomToRect:zoomRect animated:YES];
//    } else {
//        [self.scrollView zoomToRect:self.imageView.bounds animated:YES
//         ];
//    }
//}


#pragma lifecycle methods

- (void)viewDidLoad{
    [self.scrollView addSubview:self.imageView];
    self.scrollView.viewToScroll = self.imageView;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
}

- (void)viewDidAppear:(BOOL)animated{
//    [self resetImage];
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

//- (void)resetImage{
//    NSLog(@"In resetimage");
//    if (self.scrollView) {
//        self.scrollView.contentSize = CGSizeZero;
//        self.imageView.image = nil;
//        if (self.image) {
//            self.imageView.image = self.image;
//            self.imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
//            self.scrollView.zoomScale = 1.0;
//            self.scrollView.contentSize = self.image.size;
//            NSLog(@"scrollview: %@", self.scrollView);
//            NSLog(@"subviews: %@", self.scrollView.subviews);
//            NSLog(@"viewtoscroll: %@", self.scrollView.viewToScroll);
//            NSLog(@"vts is self.imageview: %d", self.scrollView.viewToScroll == self.imageView);
//            for (UITapGestureRecognizer *recognizer in self.scrollView.gestureRecognizers) {
//                NSLog(@"Gesture recognizer: %@", recognizer);
//            }
//            NSLog(@"View for scrolling: %@", [self.scrollView viewForZoomingInScrollView:self.scrollView]);
//            NSLog(@"User interaction enabled for scrollview: %d", self.scrollView.userInteractionEnabled);
//            NSLog(@"User interaction enabled for vts: %d", self.scrollView.viewToScroll.userInteractionEnabled);
//            [self.scrollView zoomToRect:self.imageView.bounds animated:NO];
//            [self.scrollView setNeedsDisplay];
//        }
//    }
//}

#pragma instantiation

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageView;
//}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

@end
