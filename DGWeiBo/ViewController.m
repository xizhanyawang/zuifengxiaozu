//
//  ViewController.m
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/26.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

//应用回调页，需要在开发平台>个人应用>应用管理>高级管理>回调URL ，进行设置
#define kRedirectURI    @"https://api.weibo.com/oauth2/default.html"


#import "ViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "DGPackageData.h"
#import "DGJSONModel.h"
#import "PullRefreshTableView.h"
#import "WeiBoTableViewCell.h"
#import "HTTPRequest.h"
#import "RootViewController.h"
#import "BaseNavigationController.h"
#import "WeiBoTableViewCell.h"

@interface ViewController ()<PullRefreshDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong , nonatomic)NewestWeiBoesModel * newsWeiboes;
@property (weak, nonatomic) IBOutlet PullRefreshTableView *weiboTableView;
@property(strong,nonatomic)NSMutableArray *arr1;

@end

@implementation ViewController{
    NSInteger _currentPage;
    BOOL _isShowSlider;
}
- (IBAction)changeAction:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex==0) {
        [DGPackageData newestPublicWeiboWithCount:@"20" page:@"1" baseApp:@"0" responseObject:^(id responseObject) {
            
            self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = NO;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
            [self.weiboTableView reloadData];
        }];

        [self.weiboTableView reloadData];
    }
    else{
        [DGPackageData attentionWeiboWithCount:@"20" page:@"1" feature:@"0" responseObject:^(id responseObject) {
            self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = NO;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
            [self.weiboTableView reloadData];
            
        }];
        [self.weiboTableView reloadData];
        
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.arr1=[NSMutableArray array];
    _currentPage = 1;
    [_weiboTableView setPDelegate:self];//设置下拉刷新的委托对象
    [_weiboTableView reloadDataFirst];//第一次刷新数据
    self.array=[NSMutableArray array];
    
}


static NSOperationQueue * queue;



- (IBAction)btnAction:(id)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    
    _currentPage = 1;
    
    if (self.segmentedControl.selectedSegmentIndex==0) {
        [DGPackageData newestPublicWeiboWithCount:@"20" page:@"1" baseApp:@"0" responseObject:^(id responseObject) {
            
            self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = NO;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
            [self.weiboTableView reloadData];
        }];
    }else{
        [DGPackageData attentionWeiboWithCount:@"20" page:@"1" feature:@"0" responseObject:^(id responseObject) {
            self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = NO;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
            [self.weiboTableView reloadData];
            
        }];
        
    }
    
}

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    _currentPage ++;
    
    NSString * page = [NSString stringWithFormat:@"%ld",_currentPage];
    if (self.segmentedControl.selectedSegmentIndex==0) {
        //抱歉，最新微博暂不支持加载更多页码的数据
        [DGPackageData newestPublicWeiboWithCount:@"40" page:page baseApp:@"0" responseObject:^(id responseObject) {
            
            
            //        NewestWeiBoesModel * wbs = responseObject;
            //
            //        self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = YES;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
        }];
    }else{
        [DGPackageData attentionWeiboWithCount:@"40" page:@"1" feature:@"0" responseObject:^(id responseObject) {
            self.newsWeiboes = responseObject;
            
            self.weiboTableView.reachedTheEnd = NO;
            
            [self.weiboTableView reloadData];
            
        } failure:^(NSError *error) {
            self.weiboTableView.isUpdataError = YES;
            self.weiboTableView.labelCenter.text = @"授权过期了";
            [self.weiboTableView reloadData];
            
        }];
        
    }
    
    


}

//我们需要将视图拖动的事件返给PullRefreshTableView
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.weiboTableView pullScrollViewDidScroll:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.weiboTableView pullScrollViewWillBeginDragging:scrollView];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   self.array = self.newsWeiboes.statuses;
    return self.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * indentifier = @"WeiBoTableViewCell";
    WeiBoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:indentifier owner:self options:nil] lastObject];
      

    }
    
    NewestWeiBoModel * weibo = self.array[indexPath.row];
    
    cell.contentTextLabel.text = weibo.text;
    [cell.commentsCountLabel setTitle:[NSString stringWithFormat:@"评论:%ld",weibo.comments_count] forState:UIControlStateNormal];
    [cell.repostsCountLabel setTitle:[NSString stringWithFormat:@"转发:%ld",weibo.reposts_count] forState:UIControlStateNormal];
 cell.attitudesCountLabel.text =[NSString stringWithFormat:@"%ld",weibo.attitudes_count];
    
    cell.timeString = weibo.created_at;
    
    cell.imageUrls = weibo.pic_urls;
    
    UserInfoModel * userInfo = weibo.user;
    
    cell.userNameLabel.text = userInfo.screen_name;
    
    [HTTPRequest downLoadImage:userInfo.avatar_large qualityRatio:1.0 pixelRatio:1.0 responseObject:^(id responseObject) {
        cell.headerImageView.image = responseObject;
        
    } failure:^(NSError *error, NSString *pathString) {
        
    }];
    cell.diaoyong=self;
    if ([self.arr1 containsObject:indexPath]) {
        [cell.btn setImage:[UIImage
                            imageNamed:@"点击后"] forState:UIControlStateNormal];
        cell.isbool=NO;
        
    }else{
        [cell.btn setImage:[UIImage
                            imageNamed:@"dianjiqian"] forState:UIControlStateNormal];
    }

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return CGRectGetHeight(cell.frame);
}

//跳转

- (IBAction)switchTouched:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:MENU_SLIDER object:nil];
}
-(void)dianzhanAction:(WeiBoTableViewCell *)cell{
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    if (![self.arr1 containsObject:indexPath]) {
        [self.arr1 addObject:indexPath];
    }
    else{
        [self.arr1 removeObject:indexPath];
    }
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)commentAction:(id)btn{
    [self performSegueWithIdentifier:@"comment" sender:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
