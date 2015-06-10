//
//  RootViewController.m
//  DGWeiBo
//
//  Created by 残狼 on 15/6/1.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "HeadTableViewCell.h"
#import "RootTableViewCell.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "DGPackageData.h"
#import "NewestWeiBoModel.h"
#import "UserInfoModel.h"
#import "PersonalMessageViewController.h"


@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSArray * array;

@property(strong,nonatomic)NewestWeiBoesModel * weibo;

@property(strong,nonatomic)NSMutableArray * userArray;

@end

@implementation RootViewController{
    
    BaseNavigationController * _homeNavigation;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //左滑
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UINavigationController * navigation = [storyboard instantiateViewControllerWithIdentifier:@"HomeNavigationController"];
    //添加子View
    [self.view addSubview:navigation.view];
    
    //添加子ViewController
    [self addChildViewController:navigation];
    
    ViewController * viewCont = (ViewController *)navigation.topViewController;
    
    _homeNavigation = navigation;
    
    AppDelegate * appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [DGPackageData gainUserInfoID:appDelegate.wbCurrentUserID responseObject:^(id responseObject) {
        
        ex_userInfo = responseObject;
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    viewCont.rootViewCont = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:182.0f/255.0f green:33.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
  
    NSDictionary * dic1 = @{@"name":@"好友资料",
                           @"headimage":@"mm1"};
    
    NSDictionary * dic2 = @{@"name":@"我的首页",
                            @"headimage":@"mm1"};
    
    NSDictionary * dic3 = @{@"name":@"修改资料",
                            @"headimage":@"mm6"};

    NSDictionary * dic4 = @{@"name":@"我的关注",
                            @"headimage":@"mm3"};
    
    NSDictionary * dic5 = @{@"name":@"我的相册",
                            @"headimage":@"mm5"};
    
    NSDictionary * dic6 = @{@"name":@"我的地址",
                            @"headimage":@"mm2"};

    NSDictionary * dic7 = @{@"name":@"设置",
                            @"headimage":@"mm4"};

    
    self.array = @[dic1,dic2,dic3,dic4,dic5,dic6,dic7];
    
    
    self.tableView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    self.tableView.layer.position = CGPointMake(SCREEN_WIDTH/2.0f, self.tableView.layer.position.y);
    self.tableView.layer.transform = CATransform3DMakeScale(_scale, _scale, 1.0);
    
    [navigation.view.layer addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    CGPoint point  = [change[NSKeyValueChangeNewKey] CGPointValue];
    CGFloat x = SCREEN_WIDTH/2.0f + (SCREEN_WIDTH/2.0f)*(point.x/(SCREEN_WIDTH - _siderEndedX));
    CGFloat scale = _scale + (1.0f - _scale)*(point.x/(SCREEN_WIDTH -_siderEndedX));
    
    self.tableView.layer.position = CGPointMake(x, self.tableView.layer.position.y);
    self.tableView.layer.transform = CATransform3DMakeScale(scale, scale, 1.0f);

}

#pragma mark- UITableViewDataSource
//添加hearView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        static NSString*stringcell=@"HeadTableViewCell";
        HeadTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:stringcell];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringcell owner:self options:nil]lastObject];
            cell.backgroundColor = [UIColor colorWithRed:182.0f/255.0f green:33.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
        }
        
        NSURL * url = [NSURL URLWithString:ex_userInfo.profile_image_url];
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        cell.headImage.image = [UIImage imageWithData:data];
        
        cell.nameLabel.text = ex_userInfo.screen_name;
        
        cell.dataiLabel.text = ex_userInfo.online_status;
        
        return cell;
    }else{
        static NSString * stringcell=@"RootTableViewCell";
        RootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:stringcell];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringcell owner:self options:nil]lastObject];
            cell.backgroundColor = [UIColor colorWithRed:182.0f/255.0f green:33.0f/255.0f blue:90.0f/255.0f alpha:1.0f];

        }
        NSDictionary * dic = self.array[indexPath.row];
        
        cell.headimage.image = [UIImage imageNamed:dic[@"headimage"]];
        
        cell.nameLabel.text = dic[@"name"];
        
        return cell;
    }
   
   
}

#pragma mark- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return CGRectGetHeight(cell.frame);
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row==0){
        
        [self performSegueWithIdentifier:@"toMessage" sender:indexPath];
        [_homeNavigation menuSlider];
        
    }else if(indexPath.row==2){
    
        [self performSegueWithIdentifier:@"toEdit" sender:self];
        [_homeNavigation menuSlider];
    }
}



#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
