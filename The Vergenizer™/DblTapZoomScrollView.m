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

#define MAX_ZOOM_SCALE 1.0
#define MIN_ZOOM_SCALE 0.1


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
    NSLog(@"addDblTapGesture getting called");
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomDoubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTap];
    self.maximumZoomScale = MAX_ZOOM_SCALE;
    self.minimumZoomScale = MIN_ZOOM_SCALE;
    self.userInteractionEnabled = YES;
    self.viewToScroll.userInteractionEnabled = YES;
    for (UIGestureRecognizer *recog in self.gestureRecognizers){
        NSLog(@"recognizer: %@", recog);
    }
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    self.touch = touch;
//    return YES;
//}

//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.viewToScroll;
//}

-(void)zoomDoubleTap{
    NSLog(@"taptap");
//    CGPoint tapLoc = [self.touch locationInView:self.viewToScroll];
//    if (self.zoomScale < self.maximumZoomScale) {
//        CGSize currentRectSize = self.bounds.size;
//        CGRect zoomRect = CGRectMake(tapLoc.x - (currentRectSize.width / 2.0), tapLoc.y - (currentRectSize.height / 2.0), (currentRectSize.width / 2.0), (currentRectSize.height / 2.0));
//        [self zoomToRect:zoomRect animated:YES];
//    } else {
//        [self zoomToRect:self.viewToScroll.bounds animated:YES
//         ];
//    }
}


@end
