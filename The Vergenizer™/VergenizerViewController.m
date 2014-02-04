//
//  VergenizerViewController.m
//  The Vergenizer
//
//  Created by Blagdon Jeffrey on 6/30/13.
//  Copyright (c) 2013 Blagdon Jeffrey. All rights reserved.
//

#import "VergenizerViewController.h"
#import "AssetObject.h"

#define OFFSET_RATIO 0.016
#define WM_ALPHA 0.2


@interface VergenizerViewController ()
@property (strong, nonatomic) AssetObject *segueAssetObject;
@end

@implementation VergenizerViewController

#pragma actions

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

- (IBAction)clearButton:(id)sender {
    [self.assetObjects removeAllObjects];
    [self.collectionView reloadData];
    self.navigationItem.prompt = nil;
    [self checkHiddenVergenizeButton];
}

- (IBAction)vergenizeButton:(id)sender {
    [self waterMarkPhotos];
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

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.collectionView layoutIfNeeded];
}


#pragma helper methods

-(void)addAssetObjects:(NSMutableArray *)objects{
    [self.assetObjects addObjectsFromArray:objects];
}

-(void)waterMarkPhotos{
    dispatch_queue_t wmQ = dispatch_queue_create("watermarking queue", NULL);
    AssetObject *ao;
    [self clearEditPrompt];
    for (ao in self.assetObjects) {
        dispatch_async(wmQ, ^{
            ALAssetOrientation orientation = [[ao.asset valueForProperty:@"ALAssetPropertyOrientation"]intValue];
            ALAssetRepresentation *thisRep = [ao.asset defaultRepresentation];
            UIImageOrientation UIOrientation = (UIImageOrientation)orientation;
            UIImage *sourceImage = [UIImage imageWithCGImage:[thisRep fullResolutionImage] scale:1.0 orientation:UIOrientation];
            CGImageRef cgImage = [sourceImage CGImage];
            CGSize targetSize = CGSizeMake(ao.outputSize, ao.outputSize * CGImageGetHeight(cgImage) / CGImageGetWidth(cgImage));
            CGRect targetRect = CGRectMake(0.0, 0.0, targetSize.width, targetSize.height);
            
            //Creating the "context" -- the opaque data type where our drawing happens. Ugh, Core Graphics.
            CGContextRef thisContext = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(cgImage), [self bytesPerRowForWidth:targetSize.width WithBitsPerPixel:CGImageGetBitsPerPixel(cgImage)], CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage));
            
            //Draw our image onto the context.
            CGContextDrawImage(thisContext, targetRect, cgImage);
            
            UIImage *watermarkImage = [UIImage imageNamed:ao.watermarkString];
            if (!watermarkImage) {
                NSLog(@"No watermark");
            }
            [self pushContext:thisContext andRotateForSize:targetSize AndOrientation:UIOrientation];
            CGContextSetAlpha(thisContext, WM_ALPHA);
            CGImageRef watermarkRef = [watermarkImage CGImage];
            
            CGRect watermarkRect = [self rectForTargetSize:targetSize wmSize:watermarkImage.size andOrientation:UIOrientation];
            CGContextDrawImage(thisContext, watermarkRect, watermarkRef);
            CGContextRestoreGState(thisContext);
            CGImageRef finalImage = CGBitmapContextCreateImage(thisContext);
            
            void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error){
                NSLog(@"Success!");
            };
            
            [self.handler.library writeImageToSavedPhotosAlbum:finalImage orientation:orientation completionBlock:completionBlock];
            
            //Don't forget to release all the Core Graphics stuff
            [self releaseCGContext:thisContext andImage:finalImage];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *removePath = [NSIndexPath indexPathForItem:0 inSection:0];
                NSArray *removePathArray = [NSArray arrayWithObject:removePath];
                if (ao != nil) {
                    [self.assetObjects removeObject:ao];
                    [self.collectionView deleteItemsAtIndexPaths:removePathArray];
                    [self checkHiddenVergenizeButton];
                }
            });
        });
    }
}

-(void)releaseCGContext:(CGContextRef)thisContext andImage:(CGImageRef)finalImage{
    UIGraphicsEndImageContext();
    CGContextRelease(thisContext);
    CGImageRelease(finalImage);
}

-(void)pushContext:(CGContextRef)context andRotateForSize:(CGSize)size AndOrientation:(UIImageOrientation)orientation{
    CGContextSaveGState(context);
    switch (orientation) {
        case UIImageOrientationUp:
            // No need to do anything
            break;
        case UIImageOrientationRight:
            CGContextTranslateCTM(context, size.width / 2, size.height / 2);
            CGContextRotateCTM(context, 0.5 * M_PI);
            CGContextTranslateCTM(context, -size.height / 2, -size.width / 2);
            break;
        case UIImageOrientationDown:
            CGContextTranslateCTM(context, size.width, size.height);
            CGContextRotateCTM(context, M_PI);
            break;
        case UIImageOrientationLeft:
            CGContextTranslateCTM(context, size.width / 2, size.height / 2);
            CGContextRotateCTM(context, 1.5 * M_PI);
            CGContextTranslateCTM(context, -size.height / 2, -size.width / 2);
        default:
            break;
    }
}

-(CGRect)rectForTargetSize:(CGSize)targetSize wmSize:(CGSize)wmSize andOrientation:(UIImageOrientation)orientation{
    if (orientation == UIImageOrientationLeft || orientation == UIImageOrientationRight) {
        return CGRectMake(targetSize.height - wmSize.width - targetSize.height * OFFSET_RATIO, targetSize.height * OFFSET_RATIO, wmSize.width, wmSize.height);
    } else {
        return CGRectMake(targetSize.width - wmSize.width - targetSize.width * OFFSET_RATIO, targetSize.width * OFFSET_RATIO, wmSize.width, wmSize.height);
    }
    }

    




- (int)bytesPerRowForWidth:(int)width WithBitsPerPixel:(int)bits{
    int bytes;
    bytes = bits * 4 * width;
    if (bytes % 16 != 0) {
        bytes = bytes + 15 - (bytes + 15) % 16;   //gets bytes up over the next highest multiple of 16 and subtracts the unused part
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

- (void)clearEditPrompt{
    self.navigationItem.prompt = nil;
}


#pragma lifecycle methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"pickerSegue"]) {
        [self clearEditPrompt];  // Animation screws up otherwise
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

#pragma instantiation

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