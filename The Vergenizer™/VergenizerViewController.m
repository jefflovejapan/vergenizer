//
//  VergenizerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 6/30/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerViewController.h"
#import "PickerViewController.h"
#import "VergenizerCVC.h"
#import "AssetObject.h"

#define OFFSET_RATIO 0.016
#define WM_ALPHA 0.2


@interface VergenizerViewController ()

@property (strong, nonatomic) AssetObject *segueAssetObject;

@end

@implementation VergenizerViewController

//Returns when collectionViewCell is tapped
- (IBAction)vergenizerCellTap:(id)sender {
    CGPoint tapLocation = [sender locationInView:self.view];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    if ([self.collectionView cellForItemAtIndexPath:indexPath]) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell && [cell isKindOfClass:[VergenizerCVC class]]) {
            VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
            self.segueAssetObject = vergenizerCVC.assetObject;
        }
        [self performSegueWithIdentifier:@"vergenizerDetailSegue" sender:self];
    }
    
}


-(void)addAssetObjects:(NSMutableArray *)objects{
    [self.assetObjects addObjectsFromArray:objects];
}

#pragma delegate methods


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numCells = self.assetObjects.count;
    return numCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vergenizerCell" forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[VergenizerCVC class]]) {
        VergenizerCVC *vergenizerCVC = (VergenizerCVC *)cell;
        AssetObject *assetObject = self.assetObjects[indexPath.item];
        vergenizerCVC.assetObject = assetObject;
        [vergenizerCVC syncImage];
    }
    return cell;
    
}



#pragma actions

- (IBAction)clearButton:(id)sender {
    [self.assetObjects removeAllObjects];
    [self.collectionView reloadData];
    self.navigationItem.prompt = nil;
    [self checkHiddenVergenizeButton];
}

- (IBAction)vergenizeButton:(id)sender {
    [self waterMarkPhotos];
}

-(void)waterMarkPhotos{
    NSLog(@"Watermarking photos into group");
//    dispatch_queue_t wmQ = dispatch_queue_create("watermarking queue", NULL);
    AssetObject *ao;
    for (ao in self.assetObjects) {
        ALAssetRepresentation *thisRep = [ao.asset defaultRepresentation];
        ALAssetOrientation orientation = [thisRep orientation];
        UIImage *sourceImage = [UIImage imageWithCGImage:[thisRep fullResolutionImage] scale:1.0 orientation:(UIImageOrientation)orientation];
        CGImageRef cgImage = [sourceImage CGImage];
        CGSize targetSize = CGSizeMake(ao.outputSize, ao.outputSize * CGImageGetHeight(cgImage) / CGImageGetWidth(cgImage));
        NSLog(@"Our targetSize is %f by %f", targetSize.width, targetSize.height);
        CGRect targetRect = CGRectMake(0.0, 0.0, targetSize.width, targetSize.height);
        
        //Creating the "context" -- the opaque data type where our drawing happens. Ugh, Core Graphics.
        CGContextRef thisContext = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(cgImage), [self bytesPerRowForWidth:targetSize.width WithBitsPerPixel:CGImageGetBitsPerPixel(cgImage)], CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage));
        
        NSLog(@"The context is %zu by %zu \n sourceImage is %f by %f \n targetSize is %f by %f", CGBitmapContextGetWidth(thisContext), CGBitmapContextGetHeight(thisContext), sourceImage.size.width, sourceImage.size.height, targetSize.width, targetSize.height);
        
        //Draw our image onto the context.
        CGContextDrawImage(thisContext, targetRect, cgImage);
        
        UIImage *watermarkImage = [UIImage imageNamed:ao.watermarkString];
        if (!watermarkImage) {
            [NSException raise:@"No watermark image" format:@"The watermark image you asked for doesn't exist"];
        }
        CGContextSaveGState(thisContext);
        CGContextSetAlpha(thisContext, WM_ALPHA);
        CGImageRef watermarkRef = [watermarkImage CGImage];
        
        CGRect watermarkRect = CGRectMake(targetSize.width - watermarkImage.size.width - targetSize.width * OFFSET_RATIO, targetSize.width * OFFSET_RATIO, watermarkImage.size.width, watermarkImage.size.height);
        CGContextDrawImage(thisContext, watermarkRect, watermarkRef);
        CGImageRef finalImage = CGBitmapContextCreateImage(thisContext);
        
        void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error){
            NSLog(@"Success!");
        };
        
        [self.handler.library writeImageToSavedPhotosAlbum:finalImage orientation:orientation completionBlock:completionBlock];
        
        //Don't forget to release all your Core Graphics stuff
        UIGraphicsEndImageContext();
        CGContextRelease(thisContext);
        CGImageRelease(finalImage);
    }
}

- (int)bytesPerRowForWidth:(int)width WithBitsPerPixel:(int)bits{
    int bytes;
    bytes = (int)(bits*4*width);
    if (bytes%16 != 0) {
        bytes = bytes+15 - (bytes+15)%16;   //gets bytes up over the next highest multiple of 16 and subtracts the unused part
    }
    return bytes;
}

- (void)checkHiddenVergenizeButton{
    if (self.assetObjects.count == 0) {
        self.vergenizeButton.hidden = YES;
    } else {
        self.vergenizeButton.hidden = NO;
    }
}


#pragma lifecycle methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        PickerViewController *pvc;
        pvc = segue.destinationViewController;
        pvc.handler = self.handler;
    }
    if ([segue.identifier isEqualToString:@"vergenizerDetailSegue"]) {
        if ([segue.destinationViewController conformsToProtocol:@protocol(DetailDelegate)]) {
            self.detailDelegate = segue.destinationViewController;
            self.detailDelegate.assetObject = self.segueAssetObject;
            self.detailDelegate.assetObjects = self.assetObjects;
        }
    }
}

- (IBAction)unwindToVergenizerViewController:(UIStoryboardSegue *)unwindSegue
{
    NSLog(@"%@", [self class]);
}


- (void)viewWillAppear:(BOOL)animated{
    [self checkHiddenVergenizeButton];
    [self.view layoutIfNeeded];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.assetObjects.count == 0){
        self.navigationItem.prompt = nil;
    } else {
        self.navigationItem.prompt = @"Tap photos to edit";
    }
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.collectionView layoutIfNeeded];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)assetObjects{
    if (!_assetObjects) {
        _assetObjects = [[NSMutableArray alloc]init];
    }
    return _assetObjects;
}

- (PhotoHandler *)handler{
    if (!_handler) {
        _handler = [[PhotoHandler alloc]init];
    }
    return _handler;
}


@end