//
//  PersonalMessageViewController.h
//  DGWeiBo
//
//  Created by  易述宏 on 15/6/2.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewestWeiBoModel;

@interface PersonalMessageViewController : UIViewController

@property (strong,nonatomic)NSMutableArray * array;

@property BOOL number;

@property (weak, nonatomic) IBOutlet UIView *btnView;

@property (strong,nonatomic)NewestWeiBoModel * weibo;

@end
