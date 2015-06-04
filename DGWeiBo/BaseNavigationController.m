//
//  BaseNavigationController.m
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/29.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//


#import "BaseNavigationController.h"

@implementation BaseNavigationController{
    UIView * _shadeView;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:182.0f/255.0f green:33.0f/255.0f blue:90.0f/255.0f alpha:1.0f]];
        [[UINavigationBar appearance] setTintColor:[self myTintColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:19],
                                                               NSForegroundColorAttributeName : [self myTintColor]}];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    [self.view addGestureRecognizer:pan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuSlider) name:MENU_SLIDER object:nil];
    
    self.view.layer.anchorPoint=CGPointMake(0, 0.5);
    self.view.layer.position=CGPointMake(0, self.view.layer.position.y);
    _shadeView=[[UIView alloc]initWithFrame:self.view.bounds];
    _shadeView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_shadeView];
    _shadeView.hidden=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [_shadeView addGestureRecognizer:tap];
}
-(void)tapGestureRecognizer:(UITapGestureRecognizer *)tap{
    [self menuSlider];
}
- (void)menuSlider{
    float scale=0;
    __block CGFloat x=self.view.frame.origin.x;
    if (x==0) {
       x = SCREEN_WIDTH - _siderEndedX;
        scale=_scale;
        _shadeView.hidden=YES;
    }else{
        x = 0;
        scale=1.0;
        _shadeView.hidden=YES;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.layer.position=CGPointMake(x, self.view.layer.position.y);
        self.view.layer.transform=CATransform3DMakeScale(scale, scale, 1.0);
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    static CGPoint startPoint;
    CGRect rect = self.view.frame;
    static CGFloat scale=1.0f;
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        startPoint  = self.view.frame.origin;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        if ((point.x + startPoint.x) < 0) {
            return;
        }
        
        rect.origin.x = point.x + startPoint.x;
        
        scale =1.0-(1.0-_scale)*(rect.origin.x)/(SCREEN_WIDTH-_siderEndedX);
        if (scale<_scale) {
            scale=_scale;
            rect.origin.x=SCREEN_WIDTH-_siderEndedX;
        };
        self.view.layer.position=CGPointMake(rect.origin.x, self.view.layer.position.y);
        self.view.layer.transform=CATransform3DMakeScale(scale, scale, 1.0);
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        if (rect.origin.x >= _siderEndedX) {
            scale = _scale;
            rect.origin.x = SCREEN_WIDTH - _siderEndedX;
            _shadeView.hidden=NO;
        }else{
            scale=1.0f;
            rect.origin.x = 0;
            _shadeView.hidden=YES;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.position=CGPointMake(rect.origin.x, self.view.layer.position.y);
            self.view.layer.transform=CATransform3DMakeScale(scale, scale, 1.0);
        }];
        
    }
    
}


- (UIColor *)myTintColor{
    return [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
