//
//  HTTPRequest.m
//  TemperatureControl
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 zhongweidi. All rights reserved.
//

#import "HTTPRequest.h"

#import "AFHTTPRequestOperation.h"

#import "AFHTTPRequestOperationManager.h"

#import "GCDCompressionImage.h"

#import "ConfigFile.h"

#import "NewestWeiBoModel.h"
#import "LocationModel.h"
#import "UserInfoModel.h"

#define HTTPTYPE @""
#define HTTPURL  @"https://api.weibo.com/2"

@implementation HTTPRequest

static AFHTTPRequestOperationManager * HTTPJSONRequestManager() {
    static AFHTTPRequestOperationManager * HTTPRequestManger;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPRequestManger = [AFHTTPRequestOperationManager manager];
        HTTPRequestManger.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return HTTPRequestManger;
}

static NSOperationQueue * downLoadImageManager() {
    static NSOperationQueue * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NSOperationQueue alloc] init];
        [manager setName:@"com.zhongweidi.downLoadImageManager"];
    });
    return manager;
    
}

//组装数据，发送请求并返回data
+ (void)packageDatas:(NSDictionary *)sendDic urlType:(NSString *)urlType responseObject:(requestData)blockObject failure:(failureError)failure{

    NSString *strURL =[HTTPURL stringByAppendingPathComponent:urlType];
        
    NSLog(@"%@", strURL);

    AFHTTPRequestOperationManager *manager = HTTPJSONRequestManager();
    
    [manager GET:strURL parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        blockObject(operation.responseString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        failure(error);
    }];
}

//上传图片
+ (void)uploadPhoto:(NSData *)imageData parameters:(NSDictionary *)parameters urlType:(NSString *)urlType fieldName:(NSString *)fieldName responseObject:(requestData)blockObject failure:(failureError)failure{

    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:HTTPURL]];
    
    AFHTTPRequestOperation *op = [manager POST:[urlType stringByAppendingString:HTTPTYPE] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData
                                    name:fieldName
                                fileName:@"photo.jpg"
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
        blockObject(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        failure(error);
    }];
    [op start];
}

//加载图片
+ (void)downLoadImage:(NSString *)URLString qualityRatio:(CGFloat)quality pixelRatio:(CGFloat)pixel responseObject:(requestData)blockObject failure:(downImageFailure)failure {
    if ([URLString isEqual:[NSNull null]]||!URLString||[URLString isEqualToString:@"ERROR_URL"]) {
        failure (nil,URLString);
        return;
    }
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *fileName = [URLString lastPathComponent];
    NSArray *SeparatedArray =[URLString componentsSeparatedByString:@"/"];
    NSString *filePath ;
    if (SeparatedArray.count>=2){
        filePath = [NSString stringWithFormat:@"%@/%@/%@",tmpPath,SeparatedArray[SeparatedArray.count-2],fileName];
        [ConfigFile createPath:[tmpPath stringByAppendingString:SeparatedArray[SeparatedArray.count-2]]];
    }
    else{
        filePath = [tmpPath stringByAppendingPathComponent:fileName];
    }
    
    NSData * data =[NSData dataWithContentsOfFile:filePath];
    
    if (data) {//判断本地是否已经存在
        blockObject([UIImage imageWithData:data]);
        return;
    }
    
    NSURL *URL;
    URL = [NSURL URLWithString:URLString];
    
    NSMutableURLRequest * request =[[NSMutableURLRequest alloc] initWithURL:URL];
    
    AFHTTPRequestOperation *posterOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    posterOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    [posterOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GCDCompressionImage * compression =[[GCDCompressionImage alloc] init];
        compression.image = responseObject;
        compression.qualityRatio = quality;
        compression.pixelRatio =pixel;
        [compression downloadRequest:filePath responseObject:^(UIImage *image) {
            blockObject(image);
        } failure:^(NSString * errorString) {
            NSLog(@"%@",errorString);
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        failure(error ,tmpPath);
        
    }];
    NSOperationQueue * queue = downLoadImageManager();
    [queue addOperation:posterOperation];
}

@end
