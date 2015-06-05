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

@interface RevisePersonalViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation RevisePersonalViewController
- (IBAction)backAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
    
        static NSString * identString = @"UserNameTableViewCell";
        UserNameTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
        }

        return cell;
        
    }else{
    
    static NSString * identString = @"ReviseTableViewCell";
    ReviseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
    }
    
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
