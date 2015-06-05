//
//  HTTPRequest.h
//  TemperatureControl
//
//  Created by apple on 14-3-31.
//  Copyright (c) 2014年 zhongweidi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^failureError)(NSError *error );

typedef void(^requestData)(id responseObject);

typedef void(^downImageFailure)(NSError * error , NSString * pathString);

typedef  void (^imageBlock)(UIImage * image);

typedef NS_ENUM(NSInteger, HTTPMethodType){
    HTTPMethodTypeGet = 0,
    HTTPMethodTypePOST = 1

};


@interface HTTPRequest : NSObject

//组装数据，发送请求并返回data
+ (void)packageDatas:(NSDictionary *)sendDic urlType:(NSString *)urlType httpMethod:(HTTPMethodType)type responseObject:(requestData)blockObject failure:(failureError)failure;

//上传图片
+ (void)uploadPhoto:(NSData *)imageData parameters:(NSDictionary *)parameters urlType:(NSString *)urlType fieldName:(NSString *)fieldName responseObject:(requestData)blockObject failure:(failureError)failure;

/*
//下载图片
+ (void)downLoadingPhoto:(NSString *)imageName ImageBolck:(void(^)(UIImage * image))ImageBolck failure:(failureError)failure;
*/


/*
 * 加载图片
 * quality : 质量系数,默认为1 (0~1)
 * pixel   : 像素系数,默认为1 (0~1)
 */
+ (void)downLoadImage:(NSString *)URLString qualityRatio:(CGFloat)quality pixelRatio:(CGFloat)pixel responseObject:(requestData)blockObject failure:(downImageFailure)failure;
@end
