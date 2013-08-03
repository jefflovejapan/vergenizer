//
//  vergenizerDetailViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 7/28/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "vergenizerDetailViewController.h"
#import "AssetObject.h"

@interface vergenizerDetailViewController ()
@property (strong, nonatomic) AssetObject *assetObject;
@property (nonatomic) NSString *watermarkString;
@property (nonatomic) NSInteger watermarkSize;
@property (strong, nonatomic) NSArray *watermarkSizes;
@property (nonatomic)CGFloat wmRatio;


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
}
- (IBAction)wmControl:(UISegmentedControl *)sender {
    self.watermarkString = [self wmStringForInteger:[sender selectedSegmentIndex]];
    self.detailView.wmView.image = [UIImage imageNamed:self.watermarkString];
    [self redrawWMView];
    [self.detailView setNeedsDisplay];
}





- (void)viewWillAppear:(BOOL)animated{
    
    //housekeeping / initializing. self.asset gets set on the segue in from vergenizerviewcontroller
    NSURL *thisURL = [self.asset valueForProperty:ALAssetPropertyAssetURL];
    NSString *thisString = [thisURL absoluteString];
    NSLog(@"The URL for self.asset is %@", thisString);
    self.assetObject = [self.handler assetObjectForString:thisString];
    
    //This sets up a variety of parameters
    [self setParamsForAssetObject:self.assetObject];
    
    //Grabbing the image
    ALAssetRepresentation *rep = [self.asset defaultRepresentation];
    ALAssetOrientation orientation = [rep orientation];
    
    //Scale = 1 here means one point = one pixel.
    UIImage *thisImage = [UIImage imageWithCGImage:[rep fullResolutionImage] scale:1 orientation:(UIImageOrientation)orientation];
    
    //Handles setting up the scrollView and subviews
    [self setViewsForImage:thisImage];
    
    //Setting the content size to be the size of the whole image
    
    [self.scrollView zoomToRect:self.detailView.bounds animated:NO];
}


//Here's all the complicated image setting stuff
- (void)setViewsForImage:(UIImage*)image{
    
    //Want to lock contentSize.width at 2040, size height to maintain aspect ratio
    self.scrollView.contentSize = CGSizeMake(2040, 2040*image.size.height/image.size.width);
    NSLog(@"At top of setViews, contentsize is %f wide, %f tall \n thisimage is %f wide, %f tall", self.scrollView.contentSize.width, self.scrollView.contentSize.height, image.size.width, image.size.height);
    
    self.detailView = [[DetailView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    NSLog(@"At top of setViews, DetailView is %f by %f", self.detailView.frame.size.width, self.detailView.frame.size.width);
    
    [self.scrollView addSubview:self.detailView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.detailView.frame];
    self.imageView = imageView;
    self.imageView.image = image;
    NSLog(@"imageView is %f wide, image is %f", self.imageView.frame.size.width, self.imageView.image.size.width);
    
    //watermark stuff
    UIImage *watermark = [UIImage imageNamed:self.watermarkString];
    CGFloat wmOffset = self.scrollView.contentSize.width*self.wmRatio;
    NSLog(@"watermark is %f by %f", watermark.size.width, watermark.size.height);
    CGRect wmRect = CGRectMake(self.scrollView.contentSize.width - watermark.size.width - wmOffset, self.scrollView.contentSize.height - watermark.size.height - wmOffset, watermark.size.width, watermark.size.height);
    UIImageView *wmView = [[UIImageView alloc]initWithImage:watermark];
    
    //adding properties to our scroll view's subview
    self.detailView.imageView = imageView;
    [self.detailView addSubview:self.detailView.imageView];
    self.detailView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
    self.detailView.wmView = wmView;
    self.detailView.wmView.frame = wmRect;
    self.detailView.wmView.alpha = 0.2;
    [self.detailView addSubview:self.detailView.wmView];

    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        NSLog(@"scrollview's subview %d is class %@", i, [self.scrollView.subviews[i] class]);
    }
        
    self.scrollView.minimumZoomScale = 0.01;
    self.scrollView.maximumZoomScale = 2.0;
}

- (NSString *)getWMString{
    NSInteger selectedWM = [self.wmControlOutlet selectedSegmentIndex];
    switch (selectedWM) {
        case 0:
            return nil;
            break;
        case 1:
            return [self wmStringForInteger:1];
            break;
        case 2:
            return [self wmStringForInteger:2];
            break;
        case 3:
            return [self wmStringForInteger:3];
            break;
        case 4:
            return [self wmStringForInteger:4];
            break;
        default:
            [NSException raise:@"Watermark doesn't exist" format:@"The name you selected for a watermark file doesn't exist"];
            return nil;
            break;
    }
}

-(void)updateWM:(NSInteger)wmInt{
    
}


//reading in parameters from the assset object
- (void)setParamsForAssetObject:(AssetObject *)assetObject{
    self.watermarkSize = assetObject.watermarkSize;
    self.watermarkString = assetObject.watermarkString;
    switch (self.watermarkSize) {
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
    if ([self.watermarkString isEqualToString:nil]) {
        self.wmControlOutlet.selectedSegmentIndex = 0;
        [self.wmControlOutlet setNeedsDisplay];
    } else if([self.watermarkString isEqualToString:[self wmStringForInteger:1]]) {
        self.wmControlOutlet.selectedSegmentIndex = 1;
        [self.wmControlOutlet setNeedsDisplay];
    } else if ([self.watermarkString isEqualToString:[self wmStringForInteger:2]]){
        self.wmControlOutlet.selectedSegmentIndex = 2;
        [self.wmControlOutlet setNeedsDisplay];
    } else if ([self.watermarkString isEqualToString:[self wmStringForInteger:3]]){
        self.wmControlOutlet.selectedSegmentIndex = 3;
        [self.wmControlOutlet setNeedsDisplay];
    } else if ([self.watermarkString isEqualToString:[self wmStringForInteger:4]]){
        self.wmControlOutlet.selectedSegmentIndex = 4;
        [self.wmControlOutlet setNeedsDisplay];
    } else {
        [NSException raise:@"No watermark match" format:@"There's no appropriate watermark for that control value"];
    }
}

- (NSString *)wmStringForInteger:(NSInteger)wmInt{
    if (wmInt == 0) {
        return nil;
    } else if (wmInt == 1){
        return [NSString stringWithFormat:@"verge_water_500_white"];
    } else if (wmInt == 2){
        return [NSString stringWithFormat:@"verge_water_500_black"];
    } else if (wmInt == 3){
        return [NSString stringWithFormat:@"verge_water_200_white_triangle"];
    } else if (wmInt == 4){
        return [NSString stringWithFormat:@"verge_water_200_black_triangle"];
    } else {
        [NSException raise:@"invalid integer" format:@"There's no wmString for that integer"];
        return nil;
    }
}

-(void)redrawWMView{
    UIImage *image = self.detailView.wmView.image;
    NSLog(@"image is %f by %f", image.size.width, image.size.height);
    CGFloat wmOffset = self.detailView.imageView.frame.size.width * self.wmRatio;
    NSLog(@"wmoffset is %f", wmOffset);
    CGRect wmRect = CGRectMake(self.detailView.imageView.frame.size.width - image.size.width - wmOffset, self.detailView.imageView.frame.size.height - image.size.height - wmOffset, image.size.width, image.size.height);
    self.detailView.wmView.frame = wmRect;
    [self.scrollView setNeedsDisplay];
    [self.detailView.wmView setNeedsDisplay];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wmRatio = 0.016;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ALAsset *)asset{
    if (!_asset) {
        _asset  = [[ALAsset alloc]init];
    }
    return _asset;
}

- (NSArray *)watermarkSizes{
    if (!_watermarkSizes) {
        NSNumber *size0 = [NSNumber numberWithInteger:560];
        NSNumber *size1 = [NSNumber numberWithInteger:640];
        NSNumber *size2 = [NSNumber numberWithInteger:1020];
        NSNumber *size3 = [NSNumber numberWithInteger:2040];
        _watermarkSizes = [NSArray arrayWithObjects:size0, size1, size2, size3, nil];
    }
    return _watermarkSizes;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    switch ([self.sizeControlOutlet selectedSegmentIndex]) {
        case 0:
            self.watermarkSize = 560;
            break;
        case 1:
            self.watermarkSize = 640;
            break;
        case 2:
            self.watermarkSize = 1020;
            break;
        case 3:
            self.watermarkSize = 2040;
            break;
            
        default:
            break;
    }
    self.watermarkString = [self wmStringForInteger:[self.wmControlOutlet selectedSegmentIndex]];
    
    if(self.allSwitchState.isOn){
        NSLog(@"switchstate returned yes");
        [self applyParamstoAll];
    } else if(!self.allSwitchState.isOn) {
        NSLog(@"switchstate returned no");
        self.assetObject.watermarkString = self.watermarkString;
        self.assetObject.watermarkSize = self.watermarkSize;
    } else{
        NSLog(@"switchstate returned nil");
    }
}

-(void)applyParamstoAll{
    NSLog(@"Inside applyParamstoAll");
    NSArray *keys = [self.handler.details allKeys];
    for (int i=0; i<keys.count; i++) {
        if (keys[i]) {
            if ([[self.handler.details objectForKey:keys[i]] isKindOfClass:[AssetObject class]]) {
                
                //careful. We want to take parameters from our assetObject property and apply to them to the objects in the dictionary.
                AssetObject *dictionaryObject = [self.handler.details objectForKey:keys[i]];
                dictionaryObject.watermarkSize = self.watermarkSize;
                dictionaryObject.watermarkString = self.watermarkString;
            }
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.detailView;
}



@end
