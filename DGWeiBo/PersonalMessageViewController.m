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
#import "WeiBoTableViewCell.h"
#import "NewestWeiBoModel.h"
#import "HTTPRequest.h"
#import "PullRefreshTableView.h"
#import "DGPackageData.h"
#import "JSONModel.h"

@interface PersonalMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{

    DGExpandheader * _header;
}

@property(strong,nonatomic)PersonalMessageHead * PersonalMessageHead;

@property (strong , nonatomic)NewestWeiBoesModel * newsWeiboes;

@property (weak, nonatomic) IBOutlet UIView * sheetView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet PullRefreshTableView  * weiboTableView;

@property(strong,nonatomic)NSMutableArray *arr1;

@end

@implementation PersonalMessageViewController


-(PersonalMessageHead *)PersonalMessageHead{

    if (!_PersonalMessageHead) {
        _PersonalMessageHead = [[[NSBundle mainBundle]loadNibNamed:@"PersonalMessageHead" owner:self options:nil]lastObject];
    }
    
    return _PersonalMessageHead;
}
//返回
- (IBAction)backAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//取消
- (IBAction)cancelAction:(id)sender {
    
    [self HeightinitWith:568];
}
//复制
- (IBAction)copyAction:(id)sender {
}
//返回首页

- (IBAction)homeAction:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = [NSMutableArray new];
    self.arr1 = [NSMutableArray new];
    [_weiboTableView setPDelegate:self];//设置下拉刷新的委托对象
    [_weiboTableView reloadDataFirst];//第一次刷新数据
    
    /*******************导航栏透明**************************/
//    UIImage *image = [UIImage imageNamed:@"nav"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.translucent = YES;
    
    /********************列表头部***************************/
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    [imageView setImage:[UIImage imageNamed:@"13.jpg"]];
    
    _header = [DGExpandheader expandWithScrollView:self.weiboTableView expandView:imageView];
    
    if (self.number) {
        
        
        UserInfoModel * userInfo = self.weibo.user;
        
        NSURL * url = [NSURL URLWithString:userInfo.profile_image_url];
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        self.PersonalMessageHead.headimage.image = [UIImage imageWithData:data];
        
        self.PersonalMessageHead.nameLabel.text = userInfo.screen_name;
        
        self.PersonalMessageHead.attentionNumber.text= userInfo.friends_count;
        
        self.PersonalMessageHead.fansNumber.text = userInfo.statuses_count;
        
    }else{
        
        self.btnView.hidden = YES;
        
        NSURL * url = [NSURL URLWithString:ex_userInfo.profile_image_url];
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        self.PersonalMessageHead.headimage.image = [UIImage imageWithData:data];
        
        self.PersonalMessageHead.nameLabel.text = ex_userInfo.screen_name;
        
        self.PersonalMessageHead.attentionNumber.text= ex_userInfo.friends_count;
        
        self.PersonalMessageHead.fansNumber.text = ex_userInfo.statuses_count;
    }
    
    self.PersonalMessageHead.headimage.layer.masksToBounds = YES;
    
    self.PersonalMessageHead.headimage.layer.cornerRadius = CGRectGetHeight(self.PersonalMessageHead.headimage.frame)/2;
    
    self.weiboTableView.tableHeaderView = self.PersonalMessageHead;
    
    /********************右按钮***************************/
    
    UIBarButtonItem * dotButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"2"] style:UIBarButtonItemStylePlain target:self action:@selector(dotAction)];
    
    UIBarButtonItem * searchButton  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"3"] style:UIBarButtonItemStylePlain target:self action:@selector(searchAction)];
    
    NSArray * array = [[NSArray alloc]initWithObjects:dotButton,searchButton, nil];
    
    self.navigationItem.rightBarButtonItems = array;
    
    
    /********************sheetView***************************/
    
    self.myScrollView.contentSize = CGSizeMake(320*2, 100);
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 59, 21)];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:15.0f];
    label.tintColor = [UIColor grayColor];
    [self.sheetView addSubview:label];
    
    CGFloat x = 0;
    
    for (int i=0; i<7; i++) {
        UIButton * bnt = [[UIButton alloc]initWithFrame:CGRectMake(8+x, 10, 60, 60)];
        NSString * string = [NSString stringWithFormat:@"%d.jpg",i+1];
        [bnt setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
        [self.myScrollView addSubview:bnt];
        x = x + 80;
    }

    [DGPackageData attentionWeiboWithCount:@"20" page:@"1" feature:@"0" responseObject:^(id responseObject) {
        
        self.weibo = responseObject;
        
        [self.weiboTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

/*下拉刷新触发方法*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{

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

/*上拉加载触发方法*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{

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

//右按钮
-(void)dotAction{

    static int a = 0;
    if (a==0) {
        
        [self HeightinitWith:283];
        
        a=1;
        
    }else{
        
        [self HeightinitWith:568];
        
        a = 0;
    }
}

-(void)HeightinitWith:(CGFloat)height{

    [UIView animateWithDuration:00.5 animations:^{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        self.sheetView.frame = CGRectMake(0, height, 320, 285);
        [UIView commitAnimations];
    }];
}

//搜索
-(void)searchAction{

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
    
    self.array =(NSMutableArray *) self.newsWeiboes.statuses;
    return self.array.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identString = @"WeiBoTableViewCell";
    WeiBoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identString];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:identString owner:self options:nil]lastObject];
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
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
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
