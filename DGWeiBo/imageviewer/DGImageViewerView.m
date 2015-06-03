//
//  DGImageViewerView.m
//  ScrollViewWithZoom
//
//  Created by zhongweidi on 14-8-14.
//  Copyright (c) 2014年 xuym. All rights reserved.
//

#import "DGImageViewerView.h"
#import "MRZoomScrollView.h"
#import "HTTPRequest.h"

#define dtIsKindOf(obj, Class)   [obj isKindOfClass:[Class class]]
#define dtIsMemberOf(obj, Class) [obj isMemberOfClass:[Class class]]

@implementation DGImageViewerView{
    CGPoint animationStartPoint;
    CGFloat animationStartRatio;
    NSMutableArray * _imageViews;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor blackColor];
        self.delegate = self;
        self.animationTime = 0.4;
        self.showIndex = 0;
        animationStartRatio = 0.0;
        animationStartPoint = CGPointMake(CGRectGetWidth(self.bounds)/2.0f, CGRectGetHeight(self.bounds)/2.0f);
        
        _imageViews = [NSMutableArray array];
    }
    return self;
}

- (void)setImagePahts:(NSArray *)imagePahts{
    _imageViews = nil;
    _imageViews = [NSMutableArray array];
    _imagePahts = imagePahts;
    int i = 0;
    for (NSString * imagePath in imagePahts) {
        MRZoomScrollView * itemView = [[MRZoomScrollView alloc] init];
        itemView.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
        CGRect rect = self.bounds;
        rect.origin.x += rect.size.width*i;
        itemView.frame = rect;
        i++;
        [self addSubview:itemView];
        [_imageViews addObject:itemView];
    }
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*i,0);
}


- (void)setImages:(NSArray *)images {
    _imageViews = nil;
    _imageViews = [NSMutableArray array];
    _images = images;
    int i = 0;
    for (UIImage * image in images) {
        MRZoomScrollView * itemView = [[MRZoomScrollView alloc] init];
        itemView.imageView.image = image;
        CGRect rect = self.bounds;
        rect.origin.x += rect.size.width*i;
        itemView.frame = rect;
        i++;
        [self addSubview:itemView];
        [_imageViews addObject:itemView];
    }
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds)*i,0);
}

- (void)setShowIndex:(NSUInteger)showIndex{
    _showIndex = showIndex;
    
    //加载高清图片
    [self downloadImage:showIndex];

    self.contentOffset =CGPointMake(CGRectGetWidth(self.bounds)*showIndex, 0);
    if (self.imageForViews) {
           [self setStartAnimationView:self.imageForViews[showIndex]];
    }
}

- (void)setStartAnimationView:(UIView *)startAnimationView{
    CGPoint point = [self relativeMostLowEndPoint:startAnimationView];
    point.x += CGRectGetWidth(startAnimationView.bounds)/2.0f;
    point.y += CGRectGetHeight(startAnimationView.bounds)/2.0f;
    animationStartPoint = point;
    animationStartRatio = startAnimationView.frame.size.width/self.bounds.size.width;
}


- (void)show:(BOOL)isShow animation:(BOOL)isAnimation{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    NSTimeInterval animationTime = _animationTime;
    if (isShow) {
        [window addSubview:self];
    }else{
        animationTime -=0.05;
        for (id view in self.subviews){
            if ([view isKindOfClass:[MRZoomScrollView class]]) {
                MRZoomScrollView * item = (MRZoomScrollView *)view;
                [item setZoomScale:1.0 animated:YES];
                item.imageView.center = CGPointMake(MRScreenWidth/2.0f, MRScreenHeight/2.0f);
            }
        }
    }
    
    if (isAnimation) {
        [self scaleAnimation:self.layer show:isShow];
        self.backgroundColor =[UIColor clearColor];
        __block UIView * backView = [[UIView alloc] initWithFrame:window.bounds];
        backView.backgroundColor = [UIColor blackColor];
        if (isShow) backView.alpha = 0.0f;
        else backView.alpha = 1.0f;
        [window addSubview:backView];
        [window bringSubviewToFront:self];
        [UIView animateWithDuration:animationTime animations:^{
            if (isShow) backView.alpha = 1.0f;
            else backView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [backView removeFromSuperview];
            backView = nil;
            if (isShow) self.backgroundColor =[UIColor blackColor];
            else [self removeFromSuperview];
        }];
    }else{
        if (!isShow) [self removeFromSuperview];
    }
    
    
}

- (void)scaleAnimation:(CALayer *)layer show:(BOOL)isShow{
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    if (isShow) {
        scaleAnimation.fromValue = [NSNumber numberWithFloat:animationStartRatio];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    }else{
        scaleAnimation.fromValue =[NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:animationStartRatio];
    }
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    scaleAnimation.duration = _animationTime;
    
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromPoint = animationStartPoint;
    CGPoint toPoint = layer.position;
    if (isShow) {
        animation.fromValue =  [NSValue valueWithCGPoint: fromPoint];
        animation.toValue = [NSValue valueWithCGPoint:toPoint];
    }else{
        animation.fromValue = [NSValue valueWithCGPoint:toPoint];
        animation.toValue = [NSValue valueWithCGPoint: fromPoint];
    }
 
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.duration = _animationTime;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = _animationTime;
    animationGroup.autoreverses = !isShow;
    animationGroup.repeatCount = 1;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [animationGroup setAnimations:@[animation,scaleAnimation]];
    
    [layer addAnimation:animationGroup forKey:@"animationGroup"];
}


- (CGPoint)relativeMostLowEndPoint:(UIView *)view
{
    CGPoint	point = CGPointZero;
	while ( view )
	{
		point.x += view.frame.origin.x;
		point.y += view.frame.origin.y;
		view = view.superview;
        if ([view isKindOfClass:[UIScrollView class]]) {
            point.x -= ((UIScrollView *) view).contentOffset.x;
            point.y -= ((UIScrollView *) view).contentOffset.y;
        }
	}
	
	return point;
}

- (void)dismissImageViewerView:(MRZoomScrollView *)zoomScrollView{
    [self show:NO animation:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger concurrentIndex = scrollView.contentOffset.x/MRScreenWidth;
    if (self.imageForViews.count>concurrentIndex) {
        UIView * view = self.imageForViews[concurrentIndex];
        CGPoint point = [self relativeMostLowEndPoint:view];
        point.x += CGRectGetWidth(view.bounds)/2.0f;
        point.y += CGRectGetHeight(view.bounds)/2.0f;
        animationStartPoint = point;
        animationStartRatio = view.frame.size.width/self.bounds.size.width;
        
        [self downloadImage:concurrentIndex];
    }
}

//下载网络图片
- (void)downloadImage:(NSInteger)concurrentIndex{
    if (self.imageUrls) {
        UIView * view = _imageViews[concurrentIndex];
        MRZoomScrollView * imageView ;
        if ([view isKindOfClass:[MRZoomScrollView class]]) {
            imageView = (MRZoomScrollView *)view;
        }
        
        [imageView.activityView startAnimating];
        [HTTPRequest downLoadImage:self.imageUrls[concurrentIndex] qualityRatio:1 pixelRatio:1 responseObject:^(id responseObject) {
            imageView.zoomScale = 1.0f;
            imageView.imageView.image = responseObject;
            [imageView.activityView stopAnimating];

        } failure:^(NSError *error, NSString *pathString) {
            [imageView.activityView stopAnimating];
            NSLog(@"地址错误!");
        }];

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
