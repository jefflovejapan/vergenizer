//
//  ImageViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/27/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController

#define MAX_ZOOM_SCALE 1.0
#define MIN_ZOOM_SCALE 0.1


#pragma actions

- (IBAction)addButtonTap:(id)sender {
    [self.delegate toggleCurrentSelection];
    [self updateAddButton];
}

- (IBAction)scrollViewTap:(id)sender {
    [self toggleNavBarVisible];
}

#pragma lifecycle

-(void)toggleNavBarVisible{
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)viewDidLoad{
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    [self.scrollView setUserInteractionEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self updateAddButton];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated{
    [self resetImage];
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;  // To enable zooming out past previous MZS
    [self.scrollView zoomToRect:[self viewForZoomingInScrollView:self.scrollView].bounds animated:YES];
    self.scrollView.minimumZoomScale = self.scrollView.zoomScale;
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
            self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;  // To enable zooming out past previous MZS
            [self.scrollView zoomToRect:zoomRect animated:NO];
            self.scrollView.minimumZoomScale = self.scrollView.zoomScale;
        }
    }
}

-(void)updateAddButton{
    if ([[self.delegate currentSelectionState]boolValue]) {
        self.addButton.title = @"Remove";
    } else {
        self.addButton.title = @"Add";
    }
}

#pragma delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

#pragma instantiation

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_imageView setUserInteractionEnabled:YES];
    }
    return _imageView;
}

@end
