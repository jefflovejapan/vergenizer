//
//  VDLandscapeViewController.m
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/4/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import "VDLandscapeViewController.h"

#define MIN_ZOOM_SCALE 0.1
#define MAX_ZOOM_SCALE 1.0
#define WM_ALPHA 0.2
#define WM_RATIO 0.016
#define SV_CONTENT_SIZE 2040

@interface vergenizerDetailViewController ()
@property (strong, nonatomic) NSArray *watermarkSizes;
@end

@implementation vergenizerDetailViewController


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
    [self setWMImageView];
}

- (void)setWMImageView {
    NSLog(@"assetObject's wmString: %@", self.assetObject.watermarkString);
    if (self.assetObject.watermarkString == nil) {
        NSLog(@"assetObject's wmString is nil so setting wmView.image = nil");
        self.detailView.wmView.image = nil;
    } else {
        self.detailView.wmView.image = [UIImage imageNamed:[self detailViewWatermarkStringForString:self.assetObject.watermarkString]];
    }
    [self redrawWMView];
}

- (void)viewWillAppear:(BOOL)animated{
    //Sets up the scrollView and subviews
    [self setViewsForAssetObject:self.assetObject];
    [self setUIFromAssetObject:self.assetObject];
    [self.scrollView zoomToRect:self.detailView.bounds animated:NO];
}

- (void)viewDidLoad{
    [self.scrollView addSubview:self.imageView];
    self.scrollView.delegate = self;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    [self.scrollView setUserInteractionEnabled:YES];
}


- (void)setViewsForAssetObject:(AssetObject *)assetObject{
    UIImage *thisImage = [self getUIImageForAssetObject:assetObject];
    //Want to lock contentSize.width at 2040 and resize height to maintain aspect ratio
    self.scrollView.contentSize = CGSizeMake(SV_CONTENT_SIZE, SV_CONTENT_SIZE * thisImage.size.height/thisImage.size.width);
    self.detailView = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    [self.scrollView addSubview:self.detailView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.detailView.frame];
    self.imageView = imageView;
    self.imageView.image = thisImage;
    
    //watermark stuff
    CGFloat wmOffset = self.imageView.frame.size.width * WM_RATIO;
    UIImage *watermark = [self wmImageForWMString:self.assetObject.watermarkString];
    
    CGRect wmRect = CGRectMake(self.imageView.frame.size.width - watermark.size.width - wmOffset, self.imageView.frame.size.height - watermark.size.height - wmOffset, watermark.size.width, watermark.size.height);
    UIImageView *wmView = [[UIImageView alloc]initWithImage:watermark];
    
    //adding properties to our scroll view's subview
    self.detailView.imageView = imageView;
    [self.detailView addSubview:self.detailView.imageView];
    self.detailView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.detailView.wmView = wmView;
    self.detailView.wmView.frame = wmRect;
    self.detailView.wmView.alpha = WM_ALPHA;
    [self.detailView addSubview:self.detailView.wmView];
    self.scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
    self.scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
}

- (UIImage *)getUIImageForAssetObject:(AssetObject *)ao{
    ALAssetRepresentation *rep = [self.assetObject.asset defaultRepresentation];
    ALAssetOrientation orientation = [rep orientation];
    
    //Scale = 1 here means one point = one pixel.
    UIImage *thisImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:1 orientation:(UIImageOrientation)orientation];
    return thisImage;
}

- (UIImage *)wmImageForWMString:(NSString *)wmString{
    if (wmString != nil) {
        return [UIImage imageNamed:[self detailViewWatermarkStringForString:self.assetObject.watermarkString]];
    } else {
        return nil;
    }
}


//reading in parameters from the asssetObject
- (void)setUIFromAssetObject:(AssetObject *)assetObject{
    NSLog(@"assetObject's watermarkSize is %d and its watermarkString is %@", assetObject.outputSize, assetObject.watermarkString);
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


-(void)redrawWMView{
    UIImage *image = self.detailView.wmView.image;
    NSLog(@"image is %f by %f", image.size.width, image.size.height);
    CGFloat wmOffset = self.detailView.imageView.frame.size.width * WM_RATIO;
    NSLog(@"wmoffset is %f", wmOffset);
    CGRect wmRect = CGRectMake(self.detailView.imageView.frame.size.width - image.size.width - wmOffset, self.detailView.imageView.frame.size.height - image.size.height - wmOffset, image.size.width, image.size.height);
    self.detailView.wmView.frame = wmRect;
    [self.scrollView setNeedsDisplay];
    [self.detailView.wmView setNeedsDisplay];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if(self.allSwitchState.isOn){
        [self applyParamstoAll];
    }
}

-(void)applyParamstoAll{
    AssetObject *ao;
    for (ao in self.assetObjects) {
        [ao setParamsFromAssetObject:self.assetObject];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.detailView;
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

@end