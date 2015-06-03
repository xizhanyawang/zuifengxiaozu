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

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)NSArray * array;

@end

@implementation RootViewController{
    
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
    
    viewCont.rootViewCont = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    NSDictionary * dic = @{@"name":@"修改资料",
                           @"headimage":@"15.jpg"};
    
    NSDictionary * dic1 = @{@"name":@"修改资料",
                            @"headimage":@"13.jpg"};
    
    NSDictionary * dic2 = @{@"name":@"修改资料",
                            @"headimage":@"10.jpg"};
    
    self.array = @[dic,dic1,dic2];
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
        }
        return cell;
    }else{
        static NSString * stringcell=@"RootTableViewCell";
        RootTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:stringcell];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:stringcell owner:self options:nil]lastObject];
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
        
        [self performSegueWithIdentifier:@"toMessage" sender:self];
        
    }else if(indexPath.row==2){
    
        [self performSegueWithIdentifier:@"toEdit" sender:self];
    }
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
