//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MRScreenWidth      [UIScreen mainScreen].bounds.size.width
#define MRScreenHeight     [UIScreen mainScreen].bounds.size.height


@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *imageView;

@property (strong , nonatomic) UIActivityIndicatorView * activityView;

@end

@interface UIView (scrollViewImageView)

- (void)dismissImageViewerView:(MRZoomScrollView *)zoomScrollView;

@end
