//
//  ConfigFile.h
//  TemperatureControl
//
//  Created by zhongweidi on 14-4-11.
//  Copyright (c) 2014年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户信息plist路径
#define PATH_USER_INFO @"userInfo.plist"

#define PATH_INFORMATION @"information.plist"

@interface ConfigFile : NSObject

//获取用户信息路径
+ (NSString *)pathUsersInfo:(NSString *)userID;


//创建路径
+ (BOOL )createPath:(NSString *)pathString;

//判断邮箱格式
+ (BOOL)checkIsEmail:(NSString *)_text;

//判断电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//判断正浮点数
+ (BOOL)validateFloat:(NSString *)mobile;

/*
//获取当天week
+ (NSInteger )getCalendarWeek:(NSDate *)date;
*/

@end
