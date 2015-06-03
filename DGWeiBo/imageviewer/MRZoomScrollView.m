//
//  MRZoomScrollView.m
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import "MRZoomScrollView.h"

@interface MRZoomScrollView ()

@end

@implementation MRZoomScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        [self setMinimumZoomScale:1.0f];
        [self setMaximumZoomScale:2.0f];
       [self initImageView];
    }
    return self;
}

- (void)awakeFromNib{
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    [self setMinimumZoomScale:1.0f];
    [self setMaximumZoomScale:2.0f];
    [self initImageView];
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.center  = CGPointMake (MRScreenWidth/2.0f, MRScreenHeight/2.0f);
        [self.imageView addSubview:_activityView];
    }
    
    return _activityView;
}

void * const _context;
- (void)initImageView
{
    self.imageView = [[UIImageView alloc]init];
    
    self.imageView.backgroundColor = [UIColor grayColor];
//    imageView.image = [UIImage imageNamed:@""];
    
    [self.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_context];
    
    self.imageView.userInteractionEnabled = YES;
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:doubleTapGesture];
    
    UITapGestureRecognizer * tapDisZoomViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDisZoomViewGesture)];
    [tapDisZoomViewGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapDisZoomViewGesture];
    
    [tapDisZoomViewGesture requireGestureRecognizerToFail:doubleTapGesture];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"image"]) {
        UIImage * image = change[NSKeyValueChangeNewKey];
        if (![image isEqual:change[NSKeyValueChangeOldKey]]) {
            if (image&&![image isEqual:[NSNull null]]) {
                CGFloat width =CGImageGetWidth(image.CGImage);
                CGFloat height=CGImageGetHeight(image.CGImage);
                CGFloat imageRatio = height/width;
                 self.contentSize = CGSizeMake(MRScreenWidth, MRScreenWidth*imageRatio);
                [(UIImageView *)object setFrame:CGRectMake(5, 0, MRScreenWidth-10, (MRScreenWidth-10)*imageRatio)];
                
              if (([(UIImageView *)object frame].size.height/2.0f)<MRScreenHeight)
                  [(UIImageView *)object setCenter:CGPointMake(MRScreenWidth/2.0f, MRScreenHeight/2.0f)];
            }
        }
    }
}

- (CGFloat)imageGetHeight:(UIImage *)image{
    CGFloat height=CGImageGetHeight(image.CGImage);
    return height;
}

#pragma mark - Zoom methods
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    if (self.zoomScale ==1.0) {
        [self setZoomScale:2.0 animated:YES];
        [self scrollViewDidZoom:self];
    } else{
        [self setZoomScale:1.0 animated:YES];
        CGFloat height = [self imageGetHeight:self.imageView.image];
        if ((height/2.0f)<MRScreenHeight) [self scrollViewDidZoom:self];
    }
}

- (void)tapDisZoomViewGesture{
    UIView * view = self.superview;
    while (view) {
        if ([view respondsToSelector:@selector(dismissImageViewerView:)]) {
            [view dismissImageViewerView:self];
            break;
        }
        view = view.superview;
    }
    
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
    CGFloat height = 0.0f;
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    CGFloat imageHeight = self.imageView.bounds.size.height*self.zoomScale;
    height = selfHeight>imageHeight? selfHeight : imageHeight;
    
    CGFloat width = 0.0f;
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat imageWidth = CGRectGetWidth(self.imageView.bounds)*self.zoomScale;
    width = selfWidth>imageWidth? selfWidth : imageWidth;
    
    self.imageView.center = CGPointMake(width/2.0f, height/2.0f);
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

- (void)dealloc{
    [self.imageView removeObserver:self forKeyPath:@"image"];
}
@end
