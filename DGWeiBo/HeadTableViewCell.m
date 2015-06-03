//
//  HeadTableViewCell.m
//  DGWeiBo
//
//  Created by 残狼 on 15/6/2.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=CGRectGetHeight(self.headImage.frame)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
