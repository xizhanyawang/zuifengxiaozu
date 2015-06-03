//
//  NewestWeiBoModel.h
//  DGWeiBo
//  ************最新公共微博*************
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "JSONModel.h"
#import "LocationModel.h"
#import "UserInfoModel.h"

@protocol NewestWeiBoModel

@end

@protocol PicModel

@end

@interface PicModel : JSONModel

@property (strong , nonatomic)NSString<Optional> * thumbnail_pic;

@end


@interface NewestWeiBoesModel : JSONModel

@property (assign , nonatomic)NSInteger hasvisible;

@property (assign , nonatomic)NSInteger  interval;

@property (strong , nonatomic)NSString * next_cursor;

@property (assign , nonatomic)NSInteger previous_cursor;


@property (strong , nonatomic)NSArray <NewestWeiBoModel> * statuses;//所有微博

@end

@interface NewestWeiBoModel : JSONModel

@property (strong ,nonatomic)NSString * created_at;//微博创建时间

@property (strong , nonatomic)NSString * id;//微博ID

@property (strong , nonatomic)NSString * mid;//微博MID

@property (strong , nonatomic)NSString * idstr;//字符串性的微博ID

@property (strong , nonatomic)NSString * text;//微博内容

@property (strong , nonatomic)NSString * source;//微博来源

@property (assign , nonatomic)BOOL favorited; //是否已收藏

@property (assign , nonatomic)BOOL truncated; //是否被拦截

@property (strong , nonatomic)NSString<Optional> * thumbnail_pic;//缩略图地址

@property (strong , nonatomic)NSString<Optional> * bmiddle_pic; //中等缩略图地址

@property (strong , nonatomic)NSString<Optional> * original_pic;//原始图缩略地址

@property (strong , nonatomic)LocationModel<Optional> * geo;//地理信息字段

@property (strong , nonatomic)UserInfoModel * user;//微博作者的用户信息字段

@property (strong , nonatomic)NewestWeiBoModel <Optional>* retweeted_status;//被转发的原微博信息字段，当该微博为转发微博时返回
//
@property (assign , nonatomic)NSInteger reposts_count;//转发数
//
@property (assign , nonatomic)NSInteger comments_count;//评论数
//
@property (assign , nonatomic)NSInteger attitudes_count;//表态数
//
//@property (assign , nonatomic)NSInteger visible;//微博的可见性及指定可见分组信息。该object中type取值，0：普通微博，1：私密微博，3：指定分组微博，4：密友微博；list_id为分组的组号

@property (strong , nonatomic)NSArray  <PicModel,Optional>* pic_urls;//微博配图ID。多图时返回多图ID，用来拼接图片url。用返回字段thumbnail_pic的地址配上该返回字段的图片ID，即可得到多个图片url。
//
//@property (strong , nonatomic)NSArray <Optional> *ad;//微博流内的推广微博ID

@end
