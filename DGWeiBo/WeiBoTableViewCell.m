//
//  WeiBoTableViewCell.m
//  DGWeiBo
//
//  Created by 钟伟迪 on 15/5/27.
//  Copyright (c) 2015年 钟伟迪. All rights reserved.
//

#import "WeiBoTableViewCell.h"
#import "DGJSONModel.h"
#import "HTTPRequest.h"
#import "ViewController.h"
void * _timeContext;
void * _contentContext;

@implementation WeiBoTableViewCell

- (void)awakeFromNib{
    _contentTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 280, 40)];
    _contentTextLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_contentTextLabel];
    _contentTextLabel.numberOfLines = 0;
    
    
    [_contentTextLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:_contentContext];
        
    _imagesView = [[ImageContentView alloc] initWithFrame:CGRectMake(20, 60, 280, 100)];
    
    _imagesView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    [self.contentView addSubview:_imagesView];
    
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = CGRectGetHeight(_headerImageView.frame)/2.0f;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGes:)];
    self.headerImageView.userInteractionEnabled = YES;
    [self.headerImageView addGestureRecognizer:tap];
    
}

-(void)tapGes:tap{

    [self.diaoyong pushImage:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    if (context == _contentContext) {
        CGRect rect = [self.contentTextLabel.text boundingRectWithSize:CGSizeMake(_contentTextLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _contentTextLabel.font} context:nil];
        
        CGRect contentTextRect = _contentTextLabel.frame;
        contentTextRect.size = rect.size;
        _contentTextLabel.frame = contentTextRect;
        
        CGRect myRect = self.frame;
        myRect.size.height = contentTextRect.size.height + 230.0f;
        self.frame = myRect;
        
        CGRect imagesViewRect = self.imagesView.frame;
        imagesViewRect.origin.y = contentTextRect.size.height + contentTextRect.origin.y + 20;
        self.imagesView.frame = imagesViewRect;
    }
    
}

- (void)setTimeString:(NSString *)timeString{
    _timeString = timeString;
        NSArray * strings = [timeString componentsSeparatedByString:@" "];
        if (strings.count >=4) {
            _timeLabel.text = [NSString stringWithFormat:@"%@",strings[3]];
            
            NSLog(@"%@",strings);
        }
}

- (void)setImageUrls:(NSArray *)imageUrls{
    _imageUrls = imageUrls;
    
    float x = 10;
    float y = 10;
    float width = 60;
    float height = 80;
    
    int i = 0;
    for (PicModel * pic in imageUrls) {
        x = 10 + (width+5)*(i%4);
        y = 10 + (height+5)*(i/4);
        WeiBoImageView  * imageView = [[WeiBoImageView alloc] init];
        imageView.frame = CGRectMake(x, y, width, height);
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.tag = i;
        [self.imagesView addSubview:imageView];
        i++;

        [HTTPRequest downLoadImage:pic.thumbnail_pic qualityRatio:1.0 pixelRatio:1.0 responseObject:^(id responseObject) {
            imageView.image = responseObject;
        } failure:^(NSError *error, NSString *pathString) {
            NSLog(@"错误");
        }];
        
    }
    
    
    int index = i%4 ? 1 : 0;
    
    //计算图片视图的尺寸
    CGRect imagesViewRect = self.imagesView.frame;
    imagesViewRect.size.height = 20 + (height+5)*(i/4 + index);
    self.imagesView.frame = imagesViewRect;
    
    //重新规划imagesView的尺寸
    CGRect rect = self.frame;
    if (i !=0) {
        rect.size.height = imagesViewRect.size.height + _contentTextLabel.frame.size.height +130;
        self.imagesView.hidden = NO;

    }else{
        rect.size.height = imagesViewRect.size.height + _contentTextLabel.frame.size.height +100;
        self.imagesView.hidden = YES;
    }
    self.frame = rect;
}


- (void)dealloc{
    [_contentTextLabel removeObserver:self forKeyPath:@"text"];
}
- (IBAction)clickAction:(id)sender {
    [self.diaoyong dianzhanAction:self];
    if (self.isbool==YES) {
        self.isbool = NO;
        [self.btn setImage:[UIImage
                            imageNamed:@"点击后"] forState:UIControlStateNormal];
    }else{
        self.isbool=YES;
        [self.btn setImage:[UIImage imageNamed:@"dianjiqian"] forState:UIControlStateNormal];
    }

}
- (IBAction)commentAction:(id)sender {
    
    [self.diaoyong commentAction:self];
}

@end


@implementation ImageContentView



@end



@implementation WeiBoImageView{
}

- (id)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        
    }
    
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.scrollView.showIndex = self.tag;
    
    [self.scrollView show:YES animation:YES];
}

- (NSArray *)imageUrls{
    if (!_imageUrls) {
        NSMutableArray * arr = [NSMutableArray new];
        for (PicModel * pic in self.cell.imageUrls) {
            NSString * string = [pic thumbnail_pic];
            if (string) {
                string = [string stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
                [arr addObject:string];
            }
        }
        _imageUrls = arr;
    }
    return _imageUrls;
}

- (WeiBoTableViewCell *)cell{
    UIView * superView = self.superview;
    while (![superView isKindOfClass:[WeiBoTableViewCell class]]) {
        superView = superView.superview;
    }
    
    WeiBoTableViewCell* cell = (WeiBoTableViewCell *)superView;
    return cell;
}
- (DGImageViewerView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[DGImageViewerView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        
        //如果我们一开始并不能直接指定到对应的Views(比如:tableView中cell上面的某个btn),可以先删除下面的语句
        NSMutableArray * images = [NSMutableArray new];
        for (UIImageView *imageView in self.cell.imagesView.subviews) {
            [images addObject:imageView.image];
        }
        _scrollView.images = images;
        
        _scrollView.imageForViews = self.cell.imagesView.subviews;//可以注释掉
        
        _scrollView.imageUrls = self.imageUrls;
    }
    return _scrollView;
}

@end
