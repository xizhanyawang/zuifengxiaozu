//
//  ViewController.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/26.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//
/*
 13320290780
 zwd3413063123
 */
#import <UIKit/UIKit.h>

@class RootViewController;
@class WeiBoTableViewCell;

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong , nonatomic)RootViewController * rootViewCont;
@property(strong,nonatomic)NSMutableArray * array;
-(void)dianzhanAction:(WeiBoTableViewCell *)btn;
-(void)commentAction:(id)btn;
@end

