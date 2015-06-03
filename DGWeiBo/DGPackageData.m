//
//  DGPackageData.m
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//
/*
 13320290780
 zwd3413063123
 */
#import "DGPackageData.h"
#import "HTTPRequest.h"
#import "AppDelegate.h"
#import "DGJSONModel.h"
#define source_token  [(AppDelegate*)[[UIApplication sharedApplication] delegate] wbtoken]

@implementation DGPackageData

+ (void)newestPublicWeiboWithCount:(NSString *)count page:(NSString *)page baseApp:(NSString *)baseApp responseObject:(requestData)blockObject failure:(failureError)failure{
    
    NSDictionary * dic = @{@"source"       : kAppKey,
                           @"access_token" : source_token,
                           @"count"        : count,
                           @"page"         : page,
                           @"base_app"     : baseApp};
    
    NSString * urlType = @"statuses/public_timeline.json";
    [HTTPRequest packageDatas:dic urlType:urlType responseObject:^(id responseObject) {
        NSError * err=nil;
        NewestWeiBoesModel* countrys = [[NewestWeiBoesModel alloc] initWithString:responseObject error:&err];
        if (err) {
            failure(err);
        }else{
            blockObject(countrys);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)attentionWeiboWithCount:(NSString *)count page:(NSString *)page
                        feature:(NSString *)feature responseObject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source"       : kAppKey,
                           @"access_token" : source_token,
                           @"count"        : count,
                           @"page"         : page,
                           @"feature"     : feature};

    NSString * urlType = @"statuses/friends_timeline.json";

    
    [HTTPRequest packageDatas:dic urlType:urlType responseObject:^(id responseObject) {
        NSError * err=nil;
        NewestWeiBoesModel* countrys = [[NewestWeiBoesModel alloc] initWithString:responseObject error:&err];
        if (err) {
            failure(err);
        }else{
            blockObject(countrys);
        }

    
    } failure:^(NSError *error) {
        failure(error);
    }];

    
}

@end
