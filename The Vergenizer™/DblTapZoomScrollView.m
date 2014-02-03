//
//  DblTapZoomScrollView.m
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/1/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import "DblTapZoomScrollView.h"

@interface DblTapZoomScrollView()
@property UITapGestureRecognizer *doubleTap;
@property UITouch *touch;
@end

@implementation DblTapZoomScrollView


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        [self addDblTapGesture];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addDblTapGesture];
    }
    return self;
}

-(void)addDblTapGesture{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomDoubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    self.userInteractionEnabled = YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.touch = touch;
    return YES;
}

-(void)zoomDoubleTap{
    NSLog(@"taptap");
    NSLog(@"min/max zoom scales: %f, %f", self.minimumZoomScale, self.maximumZoomScale);
    NSLog(@"current zoom scale: %f", self.zoomScale);
    CGPoint tapLoc = [self.touch locationInView:[self.delegate viewForZoomingInScrollView:self]];
    NSLog(@"taploc: %@", NSStringFromCGPoint(tapLoc));
    if (self.zoomScale < self.maximumZoomScale) {
        CGSize currentRectSize = self.bounds.size;
        NSLog(@"currentRectSize: %@", NSStringFromCGSize(currentRectSize));
        CGRect zoomRect = CGRectMake(tapLoc.x - (currentRectSize.width / 2.0), tapLoc.y - (currentRectSize.height / 2.0), (currentRectSize.width / 2.0), (currentRectSize.height / 2.0));
        [self zoomToRect:zoomRect animated:YES];
    } else {
        NSLog(@"inside else clause, trying to zoom to vts bounds");
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
}


@end
