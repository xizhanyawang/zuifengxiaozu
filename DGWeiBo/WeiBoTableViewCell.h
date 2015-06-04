//
//  WeiBoTableViewCell.h
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageContentView;
@class ViewController;

@interface WeiBoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong , nonatomic)NSString * timeString;

//评论数

@property (weak, nonatomic) IBOutlet UIButton *commentsCountLabel;

//转发数
@property (weak, nonatomic) IBOutlet UIButton *repostsCountLabel;

 //表态数
@property (weak, nonatomic) IBOutlet UILabel *attitudesCountLabel;


@property (strong ,nonatomic)UILabel * contentTextLabel;//内容
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong , nonatomic)NSArray * imageUrls;//图片数组URL

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;//头像

@property (strong , nonatomic) ImageContentView * imagesView;//显示微博头像
@property BOOL isbool;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property(strong,nonatomic)ViewController *diaoyong;

@end


@interface ImageContentView : UIView;

@property (strong , nonatomic)NSArray * imageUrls;//图片数组URL


@end

#import "DGImageViewerView.h"
@interface WeiBoImageView : UIImageView

@property (strong , nonatomic)NSArray * imageUrls;

@property (strong , nonatomic)DGImageViewerView * scrollView;

@end