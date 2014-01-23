//
//  vergenizerDetailViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VDetailViewController.h"
#import "AssetObject.h"

#define MIN_ZOOM_SCALE 0.01
#define MAX_ZOOM_SCALE 2.0
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
    if (self.assetObject.watermarkString == nil) {
        self.detailView.wmView.image = nil;
    } else {
        self.detailView.wmView.image = [UIImage imageNamed:[self detailViewWatermarkStringForString:self.assetObject.watermarkString]];
    }
    [self redrawWMView];
}





- (void)viewWillAppear:(BOOL)animated{
    
    //Sets up the scrollView and subviews
    [self setViewsForImage:self.assetObject];
    [self setParamsFromAssetObject:self.assetObject];
    [self.scrollView zoomToRect:self.detailView.bounds animated:NO];
}


//The complicated image-setting stuff
- (void)setViewsForImage:(AssetObject *)assetObject{
    ALAssetRepresentation *rep = [self.assetObject.asset defaultRepresentation];
    ALAssetOrientation orientation = [rep orientation];
    
    //Scale = 1 here means one point = one pixel.
    UIImage *thisImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:1 orientation:(UIImageOrientation)orientation];
    
    //Want to lock contentSize.width at 2040 and resize height to maintain aspect ratio
    self.scrollView.contentSize = CGSizeMake(SV_CONTENT_SIZE, SV_CONTENT_SIZE * thisImage.size.height/thisImage.size.width);
    
    self.detailView = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    
    [self.scrollView addSubview:self.detailView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.detailView.frame];
    self.imageView = imageView;
    self.imageView.image = thisImage;
    
    //watermark stuff
    NSString *detailViewWatermarkString = [self detailViewWatermarkStringForString:self.assetObject.watermarkString];
    UIImage *watermark = [UIImage imageNamed:detailViewWatermarkString];
    if (!watermark) {
        [NSException raise:@"No watermark image" format:@"The string provided doesn't match any available image file"];
    }
    CGFloat wmOffset = self.imageView.frame.size.width * WM_RATIO;
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


//reading in parameters from the asssetObject
- (void)setParamsFromAssetObject:(AssetObject *)assetObject{
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
        NSLog(@"switchstate returned yes");
        [self applyParamstoAll];
    } else if(!self.allSwitchState.isOn) {
        NSLog(@"switchstate returned no");
    } else{
        NSLog(@"switchstate returned nil");
    }
}

-(void)applyParamstoAll{
    for (int i=0; i<self.assetObjectSet.count; i++) {
        if ([self.assetObjectSet[i] isKindOfClass:[AssetObject class]]) {
            AssetObject *thisObject = self.assetObjectSet[i];
            thisObject.outputSize = self.assetObject.outputSize;
            thisObject.watermarkColor = self.assetObject.watermarkColor;
            thisObject.watermarkShape = self.assetObject.watermarkShape;
            // self.assetObject.watermarkString gets set automatically
        }
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


- (AssetObject *)assetObject{
    if (!_assetObject) {
        _assetObject = [[AssetObject alloc]init];
    }
    return _assetObject;
}


@end
