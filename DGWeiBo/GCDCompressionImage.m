//
//  GCDCompressionImage.m
//  iOSBCControll
//
//  Created by zhongweidi on 14-7-2.
//  Copyright (c) 2014年 hnqn. All rights reserved.
//

#import "GCDCompressionImage.h"

@interface  GCDCompressionImage()

@property (strong ,nonatomic)imageBlock imageResponseObjecBlock;
@property (strong ,nonatomic)NSString * URLString;

@end

@implementation GCDCompressionImage

//使用GCD创建单例Concurrent Dispatch Queue
static dispatch_queue_t compression_image_operation_processing_queue() {
    static dispatch_queue_t af_http_request_operation_processing_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        af_http_request_operation_processing_queue = dispatch_queue_create("com.wenkongbao.compressionImage", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return af_http_request_operation_processing_queue;
}

- (instancetype)init{
    self =[super init];
    if (!self) {
        return nil;
    }else{
        self.qualityRatio = 1.0f;
        self.pixelRatio = 1.0f;
        return self;
    }
}

- (void)start{
    dispatch_async(compression_image_operation_processing_queue(), ^{
        NSString * path =self.URLString;
        UIImage * image =[self imageContentWithSimple:self.image];
        NSData* data = UIImageJPEGRepresentation(image, 1.0);
        [data writeToFile:path atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageResponseObjecBlock(image);
        });
    });
}

- (void)downloadRequest:(NSString *)URLString
       responseObject:(void (^)(UIImage *))responseObject
              failure:(void (^)(NSString *))failure{
    self.URLString =URLString;
    self.imageResponseObjecBlock = ^(UIImage * image){
        if (image) {
            if (responseObject) {
                responseObject (image);
            }
            
        }else{
            if (failure) {
                 failure (@"请求出错！");
            }
        }
    };
    [self start];
}

//压缩图片
- (UIImage *)imageContentWithSimple:(UIImage*)image{
    CGFloat width =CGImageGetWidth(image.CGImage);
    CGFloat height=CGImageGetHeight(image.CGImage);
    width = width*self.pixelRatio;
    height = height*self.pixelRatio;
    
    NSData * data =UIImageJPEGRepresentation(image, self.qualityRatio);
    image=[UIImage imageWithData:data];
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
