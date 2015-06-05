//
//  DGPackageData.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^failureError)(NSError *error );

typedef void(^requestData)(id responseObject);


@interface DGPackageData : NSObject

/*!
 * @function 获取微博
 *
 * @abstract
 *  刷新最新公共微博
 *
 * @discussion
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  baseApp : 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 */
+ (void)newestPublicWeiboWithCount:(NSString *)count page:(NSString *)page baseApp:(NSString *)baseApp responseObject:(requestData)blockObject failure:(failureError)failure;

/*!
 * @function 获取我的微博
 *
 * @abstract
 *  刷新我的微博
 *
 * @discussion
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  feature : 过滤类型ID，0：全部、1：原创、2：图片、3：视频、4：音乐，默认为0。
 */
+ (void)attentionWeiboWithCount:(NSString *)count page:(NSString *)page
                        feature:(NSString *)feature responseObject:(requestData)blockObject failure:(failureError)failure;

/*
 * @function 获取指定发布的微博
 * @abstra
 * 拿到用户的微博
 *
 * @discussion
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  baseApp : 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 */
+(void)userSendeWeiBoWithID:(NSString *)ID page:(NSString *)page responseObject:(requestData)blockObject failure:(failureError)failure;
/*
 
 *
 * @abstract
 * //获取评论列表
 *
 * @discussion
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  baseApp : 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 */
+(void)userCommentsWithID:(NSString *)ID page:(NSString *)page reponseOject:(requestData)blockObject failure:(failureError)failure;

/*
 //发布一条评论
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  baseApp : 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 
 
 */
+(void)senderCommentsWithID:(NSString *)ID comment:(NSString *)comment rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure;



/*
 //转发一条微博
 
 *ID转发对象的ID
 
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  page  :   返回结果的页码，默认为1。
 
 *  baseApp : 是否只获取当前应用的数据。0为否（所有数据），1为是（仅当前应用），默认为0。
 */
+(void)publishWeibothID:(NSString *)ID status:(NSString *)status rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure;

/*
 //转发一条微博
 
 *  appkey : 采用OAuth授权方式不需要此参数，其他授权方式为必填参数，数值为应用的AppKey。
 
 *  token : 采用OAuth授权方式为必填参数，其他授权方式不需要此参数，OAuth授权后获得。
 
 *  count :   单页返回的记录条数，默认为50。
 
 *  rip   :开发者上报的操作用户真实IP，形如：211.156.0.1。
 */
+(void)senderNewWeibostatus:(NSString *)status rip:(NSString *)rip responseObject:(requestData)blockObject failure:(failureError)failure;

@end
