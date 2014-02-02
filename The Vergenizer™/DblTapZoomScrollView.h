//
//  DblTapZoomScrollView.h
//  The Vergenizer™
//
//  Created by Blagdon Jeffrey on 2/1/14.
//  Copyright (c) 2014 Blagdon Jeffrey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DblTapZoomScrollView : UIScrollView<UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) UIView *viewToScroll;

@end
