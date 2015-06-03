//
//  UserInfoModel.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "JSONModel.h"

@interface UserInfoModel : JSONModel
@property(strong,nonatomic)NSString *  id; //用户UID
@property(strong,nonatomic)NSString * idstr;//字符串型的用户UID
@property(strong,nonatomic)NSString * screen_name;//用户昵称
@property(strong,nonatomic)NSString * name;//友好显示名称
@property(strong,nonatomic)NSString * province;//用户所在省级ID
@property(strong,nonatomic)NSString * city;//用户所在城市ID
@property(strong,nonatomic)NSString * location;//用户所在地
//@property(strong,nonatomic)NSString * userDescription;//用户个人描述
@property(strong,nonatomic)NSString * url;//用户博客地址
@property(strong,nonatomic)NSString * profile_image_url;//用户头像地址（中图），50×50像素
@property(strong,nonatomic)NSString * profile_url;//用户的微博统一URL地址
@property(strong,nonatomic)NSString * domain;//用户的个性化域名
@property(strong,nonatomic)NSString * weihao;//用户的微号
@property(strong,nonatomic)NSString * gender;//性别，m：男、f：女、n：未知
@property(strong,nonatomic)NSString * followers_count; //粉丝数
@property(strong,nonatomic)NSString * friends_count; //关注数
@property(strong,nonatomic)NSString * statuses_count; //微博数
@property(strong,nonatomic)NSString * favourites_count; //收藏数
@property(strong,nonatomic)NSString * created_at;//用户创建（注册）时间
//@property(assign,nonatomic)BOOL following;//暂未支持
@property(assign,nonatomic)BOOL allow_all_act_msg;//是否允许所有人给我发私信，true：是，false：否
@property(assign,nonatomic)BOOL geo_enabled;//是否允许标识用户的地理位置，true：是，false：否
@property(assign,nonatomic)BOOL verified;//	是否是微博认证用户，即加V用户，true：是，false：否
//@property(assign,nonatomic)ino64_t verifiedType;//暂未支持
@property(strong,nonatomic)NSString * remark;//用户备注信息，只有在查询用户关系时才返回此字段


@property(assign,nonatomic)BOOL allow_all_comment;//是否允许所有人对我的微博进行评论，true：是，false：否
@property(strong,nonatomic)NSString * avatar_large;//用户头像地址（大图），180×180像素
@property(strong,nonatomic)NSString * avatar_hd;//用户头像地址（高清），高清头像原图
@property(strong,nonatomic)NSString * verified_reason;//认证原因
@property(assign,nonatomic)BOOL follow_me;//该用户是否关注当前登录用户，true：是，false：否
@property(strong,nonatomic)NSString * online_status; //用户的在线状态，0：不在线、1：在线
@property(strong,nonatomic)NSString *  bi_followers_count; //用户的互粉数
@property(strong,nonatomic)NSString * lang;//用户当前的语言版本，zh-cn：简体中文，zh-tw：繁体中文，en：英语
































@end
