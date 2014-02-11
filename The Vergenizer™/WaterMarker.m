//
//  WaterMarker.m
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/10/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import "WaterMarker.h"

@interface WaterMarker ()
@property (strong, nonatomic) NSMutableArray *assetObjects;
@end

@implementation WaterMarker

#define WM_ALPHA 0.2
#define OFFSET_RATIO 0.016


-(WaterMarker *) initWithAssetObjects:(NSMutableArray *)assetObjects{
    self = [super init];
    self.assetObjects = assetObjects;
    return self;
}

-(void)waterMarkPhotos{
    dispatch_queue_t wmQ = dispatch_queue_create("watermarking queue", NULL);
    AssetObject *ao;
    for (ao in self.assetObjects) {
        dispatch_async(wmQ, ^{
            //Get the objects we'll need
            ALAssetOrientation orientation = [[ao.asset valueForProperty:@"ALAssetPropertyOrientation"]intValue];
            ALAssetRepresentation *thisRep = [ao.asset defaultRepresentation];
            UIImageOrientation UIOrientation = (UIImageOrientation)orientation;
            UIImage *sourceImage = [UIImage imageWithCGImage:[thisRep fullResolutionImage] scale:1.0 orientation:UIOrientation];
            CGImageRef cgImage = [sourceImage CGImage];
            CGSize targetSize = CGSizeMake(ao.outputSize, ao.outputSize * CGImageGetHeight(cgImage) / CGImageGetWidth(cgImage));
            CGRect targetRect = CGRectMake(0.0, 0.0, targetSize.width, targetSize.height);
            
            //Create the context where our drawing happens
            CGContextRef thisContext = CGBitmapContextCreate(NULL, targetSize.width, targetSize.height, CGImageGetBitsPerComponent(cgImage), [self bytesPerRowForWidth:targetSize.width WithBitsPerPixel:CGImageGetBitsPerPixel(cgImage)], CGImageGetColorSpace(cgImage), CGImageGetBitmapInfo(cgImage));
            
            //Draw our image onto the context
            CGContextDrawImage(thisContext, targetRect, cgImage);
            [self pushContext:thisContext andRotateForSize:targetSize AndOrientation:UIOrientation];
            CGContextSetAlpha(thisContext, WM_ALPHA);
            UIImage *watermarkImage = [UIImage imageNamed:ao.watermarkString];
            if (!watermarkImage) {
                NSLog(@"No watermark");
            }
            CGImageRef watermarkRef = [watermarkImage CGImage];
            CGRect watermarkRect = [self rectForTargetSize:targetSize wmSize:watermarkImage.size andOrientation:UIOrientation];
            CGContextDrawImage(thisContext, watermarkRect, watermarkRef);
            CGContextRestoreGState(thisContext);
            CGImageRef finalImage = CGBitmapContextCreateImage(thisContext);
            
            //Finish up
            [self writeOutImage:finalImage WithOrientation:orientation];
            [self releaseCGContext:thisContext andImage:finalImage];
            [self.delegate finishedWatermarkingForAssetObject:ao];
        });
    }
}


-(void)writeOutImage:(CGImageRef)image WithOrientation:(ALAssetOrientation)orientation{
    void (^completionBlock)(NSURL *, NSError *) = ^(NSURL *assetURL, NSError *error){
        NSLog(@"Success!");
    };
    [self.delegate.handler.library writeImageToSavedPhotosAlbum:image orientation:orientation completionBlock:completionBlock];
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
@end
