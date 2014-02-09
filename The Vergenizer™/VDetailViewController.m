//
//  vergenizerDetailViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailViewController.h"

#define MIN_ZOOM_SCALE 0.1
#define MAX_ZOOM_SCALE 1.0
//#define WM_ALPHA 0.2
#define WM_RATIO 0.016
#define SV_CONTENT_SIZE 2040

@interface VDetailViewController ()
@property (strong, nonatomic) NSArray *watermarkSizes;
@end

@implementation VDetailViewController

#pragma actions

- (IBAction)allSwitch:(UISwitch *)sender {
    if (sender.on) {
        self.allSwitchLabel.text = [NSString stringWithFormat:@"For all images selected"];
    } else {
        self.allSwitchLabel.text = [NSString stringWithFormat:@"Only for this image"];
    }
    [self.allSwitchLabel setNeedsDisplay];
}

- (IBAction)sizeControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.assetObject.outputSize = 560;
            break;
        case 1:
            self.assetObject.outputSize = 640;
            break;
        case 2:
            self.assetObject.outputSize = 1020;
        case 3:
            self.assetObject.outputSize = 2040;
            break;
            
        default:
            break;
    }
}

- (IBAction)wmControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.assetObject.watermarkShape = nil;
            self.assetObject.watermarkColor = nil;
            break;
        case 1:
            self.assetObject.watermarkShape = @"logo";
            self.assetObject.watermarkColor = @"white";
            break;
        case 2:
            self.assetObject.watermarkShape = @"logo";
            self.assetObject.watermarkColor = @"black";
            break;
        case 3:
            self.assetObject.watermarkShape = @"triangle";
            self.assetObject.watermarkColor = @"white";
            break;
        case 4:
            self.assetObject.watermarkShape = @"triangle";
            self.assetObject.watermarkColor = @"black";
            break;
        default:
            break;
    }
    [self updateDetailViewWmImage];
}

- (IBAction)doneButton:(id)sender {
    if(self.allSwitchState.isOn){
        [self applyParamstoAll];
    }
    CATransition *transition = [self getPopAnimation];
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.detailView;
}

-(CATransition *)getPopAnimation{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    //kCATransitionFade; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromTop;
    //kCATransitionFromTop//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    return transition;
}


#pragma view setting

- (void)setViewsForAssetObject:(AssetObject *)assetObject{
    UIImage *thisImage = [self getUIImageForAssetObject:assetObject];

    //Want to lock contentSize.width at 2040 and resize height to maintain aspect ratio
    self.scrollView.contentSize = CGSizeMake(SV_CONTENT_SIZE, SV_CONTENT_SIZE * thisImage.size.height/thisImage.size.width);
    [self setDetailViewPhotoImage:thisImage];
    [self updateDetailViewWmImage];
}

-(void)setDetailViewPhotoImage:(UIImage *)image{
    [self.detailView setFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    self.detailView.photoImage = image;
}

-(void)updateDetailViewWmImage{
    self.detailView.wmImage = [self getDetailViewWmImage];
}


- (UIImage *)getDetailViewWmImage {
    if (self.assetObject.watermarkString == nil) {
        return nil;
    } else {
        return [UIImage imageNamed:[self detailViewWatermarkStringForString:self.assetObject.watermarkString]];
    }
}

- (UIImage *)getUIImageForAssetObject:(AssetObject *)ao{
    ALAssetRepresentation *rep = [self.assetObject.asset defaultRepresentation];
    ALAssetOrientation orientation = [rep orientation];
    
    //Scale = 1 here means one point = one pixel.
    UIImage *thisImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:1 orientation:(UIImageOrientation)orientation];
    return thisImage;
}

- (UIImage *)wmImageForWMString:(NSString *)wmString{
    if (wmString == nil) {
        return nil;
    } else {
        return [UIImage imageNamed:[self detailViewWatermarkStringForString:self.assetObject.watermarkString]];
    }
}


//reading in parameters from the asssetObject
- (void)setUIFromAssetObject:(AssetObject *)assetObject{
    switch (assetObject.outputSize) {
        case 560:
            self.sizeControlOutlet.selectedSegmentIndex = 0;
            [self.sizeControlOutlet setNeedsDisplay];
            break;
        case 640:
            self.sizeControlOutlet.selectedSegmentIndex = 1;
            [self.sizeControlOutlet setNeedsDisplay];
            break;
        case 1020:
            self.sizeControlOutlet.selectedSegmentIndex = 2;
            [self.sizeControlOutlet setNeedsDisplay];
            break;
        case 2040:
            self.sizeControlOutlet.selectedSegmentIndex = 3;
            [self.sizeControlOutlet setNeedsDisplay];
        default:
            break;
    }
    
    if (!self.assetObject.watermarkShape || !self.assetObject.watermarkColor) {
        self.wmControlOutlet.selectedSegmentIndex = 0;
        [self.wmControlOutlet setNeedsDisplay];
    }else if ([self.assetObject.watermarkShape isEqualToString:@"logo"]) {
        if ([self.assetObject.watermarkColor isEqualToString:@"white"]) {
            self.wmControlOutlet.selectedSegmentIndex = 1;
            [self.wmControlOutlet setNeedsDisplay];
        } else if ([self.assetObject.watermarkColor isEqualToString:@"black"]){
            self.wmControlOutlet.selectedSegmentIndex = 2;
            [self.wmControlOutlet setNeedsDisplay];
        }
    } else if ([self.assetObject.watermarkShape isEqualToString:@"triangle"]){
        if ([self.assetObject.watermarkColor isEqualToString:@"white"]) {
            self.wmControlOutlet.selectedSegmentIndex = 3;
            [self.wmControlOutlet setNeedsDisplay];
        }
    }
}


-(void)applyParamstoAll{
    AssetObject *ao;
    for (ao in self.assetObjects) {
        [ao setParamsFromAssetObject:self.assetObject];
    }
}

- (NSString *)detailViewWatermarkStringForString:(NSString *)string{
    NSString *returnString;
    if ([string rangeOfString:@"logo_white"].location != NSNotFound) {
        returnString = @"logo_white_500";
    } else if ([string rangeOfString:@"logo_black"].location != NSNotFound){
        returnString = @"logo_black_500";
    } else if ([string rangeOfString:@"triangle_white"].location != NSNotFound){
        returnString = @"triangle_white_200";
    } else if ([string rangeOfString:@"triangle_black"].location != NSNotFound){
        returnString = @"triangle_black_200";
    } else {
        [NSException raise:@"Invalid input string" format:@"watermarkStringForString can't return a valid string because the input string doesn't contain necessary substring"];
        returnString = nil;
    }
    return returnString;
}


#pragma lifecycle methods

-(void)viewWillAppear:(BOOL)animated{
    [self setViewsForAssetObject:self.assetObject];
    [self setUIFromAssetObject:self.assetObject];
    [self.scrollView zoomToRect:self.detailView.bounds animated:NO];
}

- (void)viewDidLoad{
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView addSubview:self.detailView];
}

#pragma instantiation

-(DetailView *)detailView{
    if (!_detailView) {
        _detailView = [[DetailView alloc]initWithFrame:CGRectZero];
    }
    return _detailView;
}
@end
