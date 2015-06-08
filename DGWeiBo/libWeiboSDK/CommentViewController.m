//
//  CommentViewController.m
//  DGWeiBo
//
//  Created by 残狼 on 15/6/4.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "CommentViewController.h"
#import "DGPackageData.h"
#import "NewestWeiBoModel.h"
#import "ConfigFile.h"
@interface CommentViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textViewOutlet;
@property(strong,nonatomic) UIView * viewOutlet;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.viewOutlet=[UIView new];
   self.viewOutlet.frame=CGRectMake(0, 528, 320, 40);
   self.viewOutlet.backgroundColor=[UIColor grayColor];
    [self.view addSubview:self.viewOutlet];
    UIButton * button=[UIButton new];
    button.frame=CGRectMake(20, 5, 80, 30);
     [button setTitle:@"显示图片" forState: UIControlStateNormal];
    [self.viewOutlet addSubview:button];
    
    self.textViewOutlet.text = @"分享新鲜事...";
    self.textViewOutlet.textColor = [UIColor grayColor];
    
    self.textViewOutlet.delegate = self;
    
    self.textViewOutlet.selectedRange = NSMakeRange(0,0);
   NSArray * ips =  [ConfigFile getIpAddresses];
    
    //通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [DGPackageData senderCommentsWithID:[NSString stringWithFormat:@"%@",self.weibo.ID] comment:[NSString stringWithFormat:@"%@",self.textViewOutlet.text] rip:[ips lastObject] responseObject:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
}


//显示键盘
-(void)keyboard:(NSNotification *)notification{
    
    NSDictionary * info = notification.userInfo;
    
    CGRect rect = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGPoint point = rect.origin;
    
    rect = self.viewOutlet.frame;
    
    rect.origin.y = point.y - rect.size.height;
    
    self.viewOutlet.frame = rect;
    
}
//开始
static bool _isBeginEditing = NO;
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    _isBeginEditing = YES;
    self.textViewOutlet.frame = CGRectMake(8, 66, 304, 120);
}
//结束
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([self.textViewOutlet.text isEqualToString:@""]) {
        self.textViewOutlet.text = @"分享新鲜事...";
        self.textViewOutlet.textColor = [UIColor grayColor];
    }
}

//当输入文字时调用
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"%@",textView.text);
    if (_isBeginEditing) {
        self.textViewOutlet.text = [textView.text stringByReplacingOccurrencesOfString:@"分享新鲜事..." withString:@""];
        self.textViewOutlet.textColor = [UIColor blackColor];
        _isBeginEditing = NO;
    }
}
//文本框的位置、长度
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if ([self.textViewOutlet.text isEqualToString:@"分享新鲜事..."]) {
        NSRange range;
        range.location = 0;
        range.length = 0;
        textView.selectedRange = range;
        
    }
}
//滑动开始中
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    CGRect rect = self.textViewOutlet.frame;
    rect.size.height = rect.size.height + 309;
    self.textViewOutlet.frame = rect;
}
//触摸结束
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if ([self.view endEditing:YES]) {
        self.textViewOutlet.frame = CGRectMake(8, 66, 304, 440);
        
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
