//
//  AppDelegate.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/26.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAppKey         @"3364315272"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbCurrentUserID;



@end

