//
//  AttentionViewController.m
//  DGWeiBo
//
//  Created by  易述宏 on 15/6/10.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionTableViewCell.h"
#import "JSONModel.h"
#import "DGPackageData.h"
#import "NewestWeiBoModel.h"
#import "HTTPRequest.h"

@interface AttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)NewestWeiBoesModel * newsWeiboes;

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DGPackageData friendshipsCount:@"20" responseObject:^(id responseObject) {
        
        self.newsWeiboes = responseObject;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.newsWeiboes.statuses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identifString = @"AttentionTableViewCell";
    AttentionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifString];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identifString owner:self options:nil]lastObject];
    }
    
    NewestWeiBoModel * weibo = self.newsWeiboes.statuses[indexPath.row];
    
    UserInfoModel * attention = weibo.user;
    
    [HTTPRequest downLoadImage:attention.avatar_large qualityRatio:1.0 pixelRatio:1.0 responseObject:^(id responseObject) {
        cell.headimage.image = responseObject;
        
    } failure:^(NSError *error, NSString *pathString) {
        
    }];
    
    return cell;
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
