//
//  CommentsModel.h
//  DGWeiBo
//
//  Created by bigbird-HZP on 15/6/3.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "JSONModel.h"
#import "UserInfoModel.h"

@protocol  CommentModel

@end


@interface CommentsModel : JSONModel

@property (strong , nonatomic)NSArray <CommentModel>* comments;

@end

@interface CommentModel : JSONModel

@property(strong,nonatomic)NSString * created_at;//评论创建时间

@property(strong,nonatomic)NSString * ID;//评论的ID

@property(strong,nonatomic)NSString * text;//评论的内容

@property(strong,nonatomic)NSString * source;//评论的来源

@property(strong,nonatomic)UserInfoModel * user;//评论作者的用户信息字段

@property(strong,nonatomic)NSString * mid;//评论的MID

@property(strong,nonatomic)NSString * idstr;//字符串型的评论ID


@end
