//
//  DGImageViewerView.h
//  ScrollViewWithZoom
//
//  Created by zhongweidi on 14-8-14.
//  Copyright (c) 2014年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGRect rects[(int)MAXFLOAT];

@interface DGImageViewerView : UIScrollView<UIScrollViewDelegate>

//指定请求的UIImage资源地址
@property (strong , nonatomic)NSArray * imagePahts;

//或者指定UIImage
@property (strong , nonatomic)NSArray * images;

//或者是网络地址
@property (strong , nonatomic)NSArray * imageUrls;

//每张图片所基于的视图(UIImageView)
@property (strong , nonatomic)NSArray * imageForViews;

@property (weak , nonatomic)UIView * startAnimationView;

//动画时间
@property (assign , nonatomic)NSTimeInterval animationTime;

//默认从第几张开始显示
@property (assign , nonatomic)NSUInteger showIndex;

//显示
- (void)show:(BOOL)isShow animation:(BOOL)isAnimation;

@end
