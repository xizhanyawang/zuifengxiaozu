//
//  PersonalMessageViewController.m
//  DGWeiBo
//
//  Created by  易述宏 on 15/6/2.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "PersonalMessageViewController.h"
#import "PersonalMessageHead.h"
#import "DGExpandheader.h"
#import "PersonalTableViewCell.h"

@interface PersonalMessageViewController ()<UITableViewDataSource,UITableViewDelegate>{

    DGExpandheader * _header;
}

@property(strong,nonatomic)PersonalMessageHead * PersonalMessageHead;

@end

@implementation PersonalMessageViewController


-(PersonalMessageHead *)PersonalMessageHead{

    if (!_PersonalMessageHead) {
        _PersonalMessageHead = [[[NSBundle mainBundle]loadNibNamed:@"PersonalMessageHead" owner:self options:nil]lastObject];
    }
    
    return _PersonalMessageHead;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*******************导航栏透明**************************/
//    UIImage *image = [UIImage imageNamed:@"nav"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    
    /********************列表头部***************************/
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    [imageView setImage:[UIImage imageNamed:@"1.jpg"]];
    
    _header = [DGExpandheader expandWithScrollView:self.tableView expandView:imageView];
    
    self.PersonalMessageHead.headimage.image = [UIImage imageNamed:@"15.jpg"];
    
    self.PersonalMessageHead.headimage.layer.masksToBounds = YES;
    
    self.PersonalMessageHead.headimage.layer.cornerRadius = CGRectGetHeight(self.PersonalMessageHead.headimage.frame)/2;
    
    self.tableView.tableHeaderView = self.PersonalMessageHead;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identString = @"PersonalTableViewCell";
    PersonalTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
    }
    return cell;
}


-(UIStatusBarStyle)preferredStatusBarStyle{

    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
