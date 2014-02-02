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


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomDoubleTap)];
        [doubleTap setNumberOfTouchesRequired:2];
        [self addGestureRecognizer:doubleTap];
        doubleTap.delegate = self;
        
    }
    return self;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.touch = touch;
    return YES;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.viewToScroll;
}

-(void)zoomDoubleTap{
    CGPoint tapLoc = [self.touch locationInView:self.viewToScroll];
    if (self.zoomScale < self.maximumZoomScale) {
        CGSize currentRectSize = self.bounds.size;
        CGRect zoomRect = CGRectMake(tapLoc.x - (currentRectSize.width / 2.0), tapLoc.y - (currentRectSize.height / 2.0), (currentRectSize.width / 2.0), (currentRectSize.height / 2.0));
        [self zoomToRect:zoomRect animated:YES];
    } else {
        [self zoomToRect:self.viewToScroll.bounds animated:YES
         ];
    }
}


@end
