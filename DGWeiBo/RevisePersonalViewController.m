//
//  RevisePersonalViewController.m
//  DGWeiBo
//
//  Created by  易述宏 on 15/6/3.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "RevisePersonalViewController.h"
#import "UserNameTableViewCell.h"
#import "ReviseTableViewCell.h"
#import "DGJSONModel.h"

@interface RevisePersonalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSMutableArray * array;

@end

@implementation RevisePersonalViewController
- (IBAction)backAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary * dic1 =@{@"title":@"登录名",
                           @"name":@"13548908931"};
    
    NSDictionary * dic2 = @{@"title":@"昵称",
                            @"screen_name":ex_userInfo.screen_name};
    
    NSDictionary * dic4 = @{@"title":@"性别",
                            @"sex":@"女"};
    
    NSDictionary * dic5 = @{@"title":@"所在地",
                            @"city":@"湖南长沙"};
    
    self.array = [NSMutableArray arrayWithObjects:dic1,dic2,dic4,dic5,nil];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * dic = self.array[indexPath.row];
    if(indexPath.row==0){
    
        static NSString * identString = @"UserNameTableViewCell";
        UserNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
        }

        cell.userNameLabel.text = dic[@"title"];
        
        cell.nameLabel.text =dic[@"name"];
        
        return cell;
        
    }else if(indexPath.row==1){
    
    static NSString * identString = @"ReviseTableViewCell";
    ReviseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
    }
        cell.nameLabel.text = dic[@"title"];
        cell.amendText.text = dic[@"screen_name"];
    return cell;
        
    }else if(indexPath.row==2){
    
        static NSString * identString = @"ReviseTableViewCell";
        ReviseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
        }
        
        cell.nameLabel.text = dic[@"title"];
        cell.amendText.text = dic[@"sex"];
        return cell;
    }else{
    
        static NSString * identString = @"ReviseTableViewCell";
        ReviseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
        }
        
        cell.nameLabel.text = dic[@"title"];
        cell.amendText.text = dic[@"city"];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
