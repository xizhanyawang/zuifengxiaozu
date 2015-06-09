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
#import "AFNetworking.h"

#define source_token  [(AppDelegate*)[[UIApplication sharedApplication] delegate] wbtoken]

@implementation DGPackageData

//////  刷新最新公共微博
+ (void)newestPublicWeiboWithCount:(NSString *)count page:(NSString *)page baseApp:(NSString *)baseApp responseObject:(requestData)blockObject failure:(failureError)failure{
    
    NSDictionary * dic = @{@"source"       : kAppKey,
                           @"access_token" : source_token,
                           @"count"        : count,
                           @"page"         : page,
                           @"base_app"     : baseApp};
    
    NSString * urlType = @"statuses/public_timeline.json";
    [HTTPRequest packageDatas:dic urlType:urlType httpMethod:HTTPMethodTypeGet responseObject:^(id responseObject) {
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

////// 刷新我的微博/////

+ (void)attentionWeiboWithCount:(NSString *)count page:(NSString *)page
                        feature:(NSString *)feature responseObject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source"       : kAppKey,
                           @"access_token" : source_token,
                           @"count"        : count,
                           @"page"         : page,
                           @"feature"     : feature};

    NSString * urlType = @"statuses/friends_timeline.json";

    
    [HTTPRequest packageDatas:dic urlType:urlType httpMethod:HTTPMethodTypeGet responseObject:^(id responseObject) {
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

/*
 * 获取指定发布的微博
 * 拿到用户的微博
 */

+(void)userSendeWeiBoWithID:(NSString *)ID page:(NSString *)page responseObject:(requestData)blockObject failure:(failureError)failure{
    
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"uid":ID,
                           @"page":page};
    
    NSString * urlString = @"statuses/user_timeline.json";
    [HTTPRequest packageDatas:dic urlType:urlString httpMethod:HTTPMethodTypeGet   responseObject:^(id responseObject) {
        NSError * error;
        NewestWeiBoesModel * wbs = [[NewestWeiBoesModel alloc] initWithString:responseObject error:&error];
        if (error) {
            NSLog(@"错误%@",error);
            failure(error);
        }else{
            blockObject(wbs);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    
}



//获取评论列表
+(void)userCommentsWithID:(NSString *)ID page:(NSString *)page reponseOject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"id":ID,
                           @"page":page};
    NSString * urlstring = @"comments/show.json";
    [HTTPRequest packageDatas:dic urlType:urlstring httpMethod:HTTPMethodTypeGet   responseObject:^(id responseObject) {
        NSError * error;
        CommentsModel * wbs = [[CommentsModel alloc] initWithString:responseObject error:&error];
        if (error) {
            NSLog(@"错误%@",error);
            failure(error);
        }else{
            blockObject(wbs);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

//发布评论
+(void)senderCommentsWithID:(NSString *)ID comment:(NSString *)comment rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"id":ID,
                           @"comment":comment,
                           @"rip":rip};
    NSString * urlString = @"comments/create.json";
    
    [HTTPRequest packageDatas:dic urlType:urlString httpMethod:HTTPMethodTypePOST responseObject:^(id responseObject) {
        NSError * error;
        CommentModel * weibo = [[CommentModel alloc] initWithString:responseObject error:&error];
        if(error){
            NSLog(@"%@",error);
            failure(error);
        }else{
            blockObject(weibo);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//转发一条微博
+(void)publishWeibothID:(NSString *)ID status:(NSString *)status rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure{
    
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"id":ID,
                           @"status":status,
                           @"rip":rip};
    NSString * urlString = @"statuses/update.json";
    
    [HTTPRequest packageDatas:dic urlType:urlString httpMethod:HTTPMethodTypePOST responseObject:^(id responseObject) {
        NSError * error;
        NewestWeiBoModel * wbs = [[NewestWeiBoModel alloc] initWithString:responseObject error:&error];
        if (error) {
            NSLog(@"错误%@",error);
            failure(error);
        }else{
            blockObject(wbs);
        }
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//发布一条微博

+(void)senderNewWeibostatus:(NSString *)status rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"status":status,
                           @"rip":rip};
    NSString * urlstring = @"statuses/update.json";
    [HTTPRequest packageDatas:dic urlType:urlstring httpMethod:HTTPMethodTypePOST responseObject:^(id responseObject) {
        NSError * error;
        NewestWeiBoModel * wb = [[NewestWeiBoModel alloc] initWithString:responseObject error:&error];
        if (error) {
            NSLog(@"错误%@",error);
            failure(error);
        }else{
            blockObject(wb);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

//获取用户信息
+(void)gainUserInfoID:(NSString *)UserId responseObject:(requestData)blockObject failure:(failureError)failure{
    NSDictionary * dic = @{@"source":kAppKey,
                           @"access_token":source_token,
                           @"uid":UserId};
    NSString * urlstring = @"users/show.json";
    [HTTPRequest packageDatas:dic urlType:urlstring httpMethod:HTTPMethodTypeGet responseObject:^(id responseObject) {
        NSError * error;
        UserInfoModel * currentUser = [[UserInfoModel alloc]initWithString:responseObject error:&error];
        if(error){
        
            NSLog(@"错误%@",error);
            
            failure(error);
        }else{
        
            blockObject(currentUser);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];

}


@end
