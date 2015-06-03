//
//  BaseNavigationController.m
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/29.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "BaseNavigationController.h"

@implementation BaseNavigationController

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
    
    

}

- (void)menuSlider{
    CGRect rect = self.view.frame;
    if (rect.origin.x ==0) {
        rect.origin.x = SCREEN_WIDTH - _siderEndedX;
    }else{
        rect.origin.x = 0;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = rect;
    }];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

static float _siderEndedX = 80.0f;
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan translationInView:self.view];
    static CGPoint startPoint;
    CGRect rect = self.view.frame;
    
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        startPoint  = self.view.frame.origin;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        if ((point.x + startPoint.x) < 0) {
            return;
        }
        
        rect.origin.x = point.x + startPoint.x;
        
        //        CGFloat scale = (SCREEN_WIDTH - rect.origin.x)/SCREEN_WIDTH;
        
    }else if (pan.state == UIGestureRecognizerStateEnded){
        if (self.view.frame.origin.x >= SCREEN_WIDTH/2.0f) {
            rect.origin.x = SCREEN_WIDTH - _siderEndedX;
//            self.weiboTableView.userInteractionEnabled = NO;
        }else{
            rect.origin.x = 0;
//            self.weiboTableView.userInteractionEnabled = YES;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = rect;
        }];
        
    }
    
    self.view.frame = rect;
}


- (UIColor *)myTintColor{
    return [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

//设置状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
