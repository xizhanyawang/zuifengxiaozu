//
//  PullRefreshTableView.m
//  demo0425
//
//  Created by zhongweidi on 14-4-25.
//  Copyright (c) 2014年 hnqn. All rights reserved.
//

//获取设备物理高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//获取设备物理宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define refreshTintColor [UIColor grayColor]
#define KAttributedColor [UIColor grayColor]
#define ATTRIBUTRD_TITLE @"正在加载数据"
#define END_TITLE @"没有了哦"
#define UPDATA_TITLT @"数据刷新中,请稍后..."
#define UPDATAING_TITLE @"正在加载..."
#define UPDATA_ERROR_TITLE @"加载失败,点我重新加载"

#import "PullRefreshTableView.h"

@interface PullRefreshTableView(){
    BOOL isUpdataing;
    BOOL isFirstLoadData;
    BOOL isBeginSrolling;
}

@property (nonatomic ,strong)UIActivityIndicatorView * activityCenter;

@property (nonatomic ,strong)bottomView * UpView;
@property (nonatomic ,strong)UIRefreshControl * refresh;

@end

@implementation PullRefreshTableView

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.PDelegate=delegate;
        self.delegate=delegate;
        self.dataSource=delegate;
        
        self.reachedTheEnd = YES;
        UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
        refresh.tintColor = refreshTintColor;
        refresh.backgroundColor =[UIColor clearColor];
        refresh.attributedTitle = [self setAttriString:UPDATA_TITLT];
        [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        self.refresh=refresh;
        [self addSubview:_refresh];
        self.tableFooterView=self.UpView;
        
    }
    return self;
}

- (void)awakeFromNib{
    self.reachedTheEnd = YES;
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = refreshTintColor;
    refresh.backgroundColor =[UIColor clearColor];
    refresh.attributedTitle = [self setAttriString:UPDATA_TITLT];
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refresh=refresh;
    [self addSubview:_refresh];
    self.tableFooterView=self.UpView;
    
}

- (void)setPDelegate:(id<PullRefreshDelegate>)pDelegate{
    _pDelegate=pDelegate;
    self.delegate=(id)pDelegate;
    self.dataSource=(id)pDelegate;
}



- (bottomView *)UpView{
    if (!_UpView) {
        _UpView =[[bottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _UpView.backgroundColor=[UIColor clearColor];
        [_UpView.activityBtm startAnimating];
        
    }
    return _UpView;
}

- (UILabel *)labelCenter{
    if (!_labelCenter) {
        _labelCenter=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2.0f, 30)];
        _labelCenter.center=CGPointMake(SCREEN_WIDTH/2.0,SCREEN_HEIGHT/2.0);
        _labelCenter.textAlignment=NSTextAlignmentCenter;
        _labelCenter.textColor=[UIColor grayColor];
        _labelCenter.font =[UIFont boldSystemFontOfSize:15];
        _labelCenter.backgroundColor=[UIColor clearColor];
        UITapGestureRecognizer *tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadDataAgain)];
        [_labelCenter addGestureRecognizer:tapGes];
        _labelCenter.text =UPDATAING_TITLE;
        [self.superview addSubview:_labelCenter];
    }
    return _labelCenter;
}

- (UIActivityIndicatorView *)activityCenter{
    if (!_activityCenter) {
        _activityCenter =[[UIActivityIndicatorView alloc]
                       initWithFrame : CGRectMake(0 ,0, 32.0f, 32.0f)];
        _activityCenter.center =CGPointMake(100,SCREEN_HEIGHT/2.0);
        _activityCenter.color=[UIColor blackColor];
        [_activityCenter setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.superview addSubview:_activityCenter];
    }
    return _activityCenter;
}


- (void)reloadDataFirst{
    [self.activityCenter startAnimating];
    isFirstLoadData=YES;
    self.hidden=YES;
    self.labelCenter.text=UPDATAING_TITLE;
    [self.pDelegate upLoadDataWithTableView:self];
}

//加载失败重新加载
- (void)loadDataAgain{
    [self.activityCenter startAnimating];
    self.labelCenter.text=UPDATAING_TITLE;
    self.labelCenter.userInteractionEnabled=NO;
    [self.pDelegate upLoadDataWithTableView:self];
}


- (void)reloadData{
    [super reloadData];
    
    if(!isFirstLoadData){
        if (self.activityCenter.isAnimating) [self.activityCenter stopAnimating];
        if (self.isUpdataError) {
            self.labelCenter.hidden=NO;
            self.labelCenter.userInteractionEnabled=YES;
            self.labelCenter.text =UPDATA_ERROR_TITLE;
            self.isUpdataError=NO;
        }
        else  {
            self.labelCenter.hidden=YES;
            self.labelCenter.userInteractionEnabled=NO;
        }
        
        self.hidden=NO;
        
    }else isFirstLoadData=NO;
    
    
    if (self.contentSize.height<self.frame.size.height) {
        self.UpView.hidden=YES;
    }else{
        self.UpView.hidden=NO;
    }


    if (_reachedTheEnd) {
      self.UpView.labelBtm.text=@"加载完成";
    }else{
      self.UpView.labelBtm.text=END_TITLE;
    }
    
    NSString *s = [NSString stringWithFormat:@"最后更新: %@", [self getDateString:[NSDate date]]];
    self.refresh.attributedTitle = [self setAttriString:s];
    [self.refresh endRefreshing];
    [self.UpView.activityBtm stopAnimating];
    isUpdataing=YES;
    
    [self saveUpdataTime];
}

//下拉缓冲
-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        isUpdataing=NO;
        _reachedTheEnd=YES;
        
        self.UpView.labelBtm.text=UPDATA_TITLT;
        refresh.attributedTitle = [self  setAttriString:UPDATA_TITLT];
       
        
        if (_isUpdataError) {
            self.labelCenter.text=UPDATA_ERROR_TITLE;
            self.labelCenter.hidden=NO;
        }else{
            self.labelCenter.hidden=YES;
            _isUpdataError=NO;
        }
        
        /**///刷新数据
        [self.UpView.activityBtm stopAnimating];
        [self.pDelegate  upLoadDataWithTableView:self];
        /**/
    }
}

#pragma mark - ScrollDelegate
-(void)pullScrollViewDidScroll:(UIScrollView *)scrollView{
    float ScrollAllHeight =scrollView.contentOffset.y+scrollView.frame.size.height;
    float tabviewSizeHeight =scrollView.contentSize.height;
    if (ScrollAllHeight>tabviewSizeHeight && _reachedTheEnd&&isUpdataing&&!self.UpView.hidden) {
        [self.UpView.activityBtm startAnimating];
        self.UpView.labelBtm.text=UPDATAING_TITLE;
         isUpdataing=NO;
        //上拉加载数据
        [self.pDelegate refreshDataWithTableView:self];
       
    }
    
    //禁止刷新时往上滑动，sectionHeader会出现BUG
    if (self.refresh.refreshing&&_isUpDataingScrollEnabled) {
        if (scrollView.contentOffset.y>-61.0f) {
            scrollView.contentOffset=CGPointMake(scrollView.contentOffset.x, -61.0f);
        }
    }
    
    if (scrollView.contentOffset.y<0&&isBeginSrolling) {
        isBeginSrolling = NO;
        NSString *s = [NSString stringWithFormat:@"最后更新: %@", [self getDateString:[NSDate date]]];
        self.refresh.attributedTitle = [self setAttriString:s];
    }
}

- (void)pullScrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (isUpdataing) isBeginSrolling = YES;
}

/********************************************************************************************************/
/********************************************************************************************************/
- (void)saveUpdataTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * stringDate =[formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:stringDate forKey:@"histroyDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Mode
- (NSMutableAttributedString *)setAttriString:(NSString *)s{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:s];
    NSDictionary *refreshAttributes = @{NSForegroundColorAttributeName:KAttributedColor,};
    [attriString setAttributes:refreshAttributes range:NSMakeRange(0, attriString.length)];
    return attriString;
}

#pragma mark - timerData
- (NSString *)getDateString:(NSDate *)date{
    
    NSTimeInterval timeHistroy;
    NSString *stringDate;
    NSTimeInterval timeNow = [date timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if ([self getHistroy]) {
        NSDate *dateHistroy =[formatter dateFromString:[self getHistroy]];
        timeHistroy =[dateHistroy timeIntervalSince1970];
    }else{
        timeHistroy=timeNow;
    }
    
    stringDate =[formatter stringFromDate:date];

    int timeDifference =(int)(timeNow -timeHistroy);
    if (timeDifference<60)stringDate =@"刚刚";
    else if (timeDifference<60*60) stringDate =[NSString stringWithFormat:@"%d分钟前",(int)timeDifference/60];
    else if (timeDifference<60*60*24) stringDate =[NSString stringWithFormat:@"%d小时前",(int)timeDifference/(60*60)];
    else if (timeDifference<60*60*24*7) stringDate =[NSString stringWithFormat:@"%d天前",(int)timeDifference/(60*60*24)];
    
    return stringDate;
}

- (NSString *)getHistroy{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"histroyDate"];
}

@end

/***********************************/

/***********************************/

/***********************************/

/***********************************/

@interface bottomView()

@end

@implementation bottomView

- (id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {

        self.labelBtm.text=END_TITLE;
    }
    return self;
}


- (UIActivityIndicatorView *)activityBtm{
    if (!_activityBtm) {
        _activityBtm =[[UIActivityIndicatorView alloc]
                       initWithFrame : CGRectMake(0 ,0, 32.0f, 32.0f)];
        _activityBtm.center =CGPointMake(60, self.frame.size.height/2.0f);
        _activityBtm.color=[UIColor blackColor];
        [_activityBtm setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityBtm];
    }
    return _activityBtm;
}

- (UILabel *)labelBtm{
    if (!_labelBtm) {
        _labelBtm =[[UILabel alloc] init];
        _labelBtm.frame =CGRectMake( 0, 0, SCREEN_WIDTH/2.0f, 20);
        _labelBtm.center =CGPointMake(SCREEN_WIDTH/2.0, self.frame.size.height/2.0f);
        _labelBtm.textColor=[UIColor grayColor];
        _labelBtm.textAlignment=NSTextAlignmentCenter;
        _labelBtm.font =[UIFont boldSystemFontOfSize:14];
        _labelBtm.backgroundColor =[UIColor clearColor];
        [self addSubview:_labelBtm];
    }
    return _labelBtm;
}

@end
