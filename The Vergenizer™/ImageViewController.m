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

#define MAX_ZOOM_SCALE = 2.0;
#define MIN_ZOOM_SCALE = 0.5;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

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


@end
