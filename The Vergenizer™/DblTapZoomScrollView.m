//
//  DblTapZoomScrollView.m
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/1/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import "DblTapZoomScrollView.h"

@interface DblTapZoomScrollView()
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

-(void)awakeFromNib{
    [super awakeFromNib];
    [self addDblTapGesture];
}


-(void)addDblTapGesture{
    self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomDoubleTap)];
    [self.doubleTap setNumberOfTapsRequired:2];
    [self addGestureRecognizer:self.doubleTap];
    [self setUserInteractionEnabled:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    self.touch = touch;
    return YES;
}

-(void)zoomDoubleTap{
    CGPoint tapLoc = [self.touch locationInView:[self.delegate viewForZoomingInScrollView:self]];
    if (self.zoomScale < self.maximumZoomScale) {
        CGSize currentRectSize = self.bounds.size;
        CGRect zoomRect = CGRectMake(tapLoc.x - (currentRectSize.width / 2.0), tapLoc.y - (currentRectSize.height / 2.0), (currentRectSize.width / 2.0), (currentRectSize.height / 2.0));
        [self zoomToRect:zoomRect animated:YES];
    } else {
        CGRect minRect = [self.delegate viewForZoomingInScrollView:self].bounds;
        [self zoomToRect:minRect animated:YES];
    }
}


@end
