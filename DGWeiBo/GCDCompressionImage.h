//
//  GCDCompressionImage.h
//  iOSBCControll
//
//  Created by zhongweidi on 14-7-2.
//  Copyright (c) 2014年 hnqn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef  void (^imageBlock)(UIImage * image);


@interface GCDCompressionImage : NSObject

- (void)downloadRequest:(NSString *)URLString responseObject:(void(^)(UIImage * image))responseObject failure:(void (^)(NSString *))failure;

@property (strong ,nonatomic) UIImage * image;

//质量系数默认为1 (0~1)
@property (assign ,nonatomic) CGFloat qualityRatio;

//像素系数,默认为1 (0~1)
@property (assign ,nonatomic) CGFloat pixelRatio;

@end
