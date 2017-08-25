//
//  AdvertiseView.m
//  新闻
//
//  Created by 谢风 on 2017/8/25.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "AdvertiseView.h"

@interface AdvertiseView()

@property(nonatomic,strong)UIImageView *adView;
@property(nonatomic,strong)UIImageView *NewView;
@property(nonatomic,strong)UIButton *countBtn;
@property(nonatomic,strong)NSTimer *countTimer;
@property(nonatomic,assign)NSInteger count;

@end

//广告显示时间
static NSInteger const showTime =5;

@implementation AdvertiseView
-(NSTimer *)countTimer{
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //1.广告图片
        _adView = [[UIImageView alloc]initWithFrame:frame];
        _adView.userInteractionEnabled =YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToAd)];
        [_adView addGestureRecognizer:tap];
        
        //2.本地图片
        _NewView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 350,330,217)];
        UIImage *image = [UIImage imageNamed:@"News.jpg"];
        _NewView.image = image;
        _NewView.userInteractionEnabled = NO;
        [_adView addSubview:_NewView];
        
        
        //3.跳过按钮
        CGFloat btnW =60;
        CGFloat btnH = 30;
        _countBtn = [[UIButton alloc]initWithFrame:CGRectMake(kscreenWidth - btnW-24, btnH, btnW, btnH)];
        [_countBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%ld",showTime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _countBtn.backgroundColor = [UIColor grayColor];
        _countBtn.alpha = 0.6;
        _countBtn.layer.cornerRadius = 10;//圆角角度
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
    }
    return self;
}
-(void)setFilePath:(NSString *)filePath{
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}
-(void)pushToAd{
    [self dismiss];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pushtoad" object:nil userInfo:nil];
}
-(void)countDown{
    _count--;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%ld",_count] forState:UIControlStateNormal];
    
    if (_count == 0) {
        [self dismiss];
    }
}
-(void)show{
    /* 倒计时的方法有两种:1.GCD 2.定时器*/
    //1.GCD
    //[self startCoundown];
    
    //2.定时器
    [self startTimer];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}
//定时器倒计时
-(void)startTimer{
    _count = showTime;
    [[NSRunLoop mainRunLoop]addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
//GCD倒计时
-(void)startCoundown{
    __block NSInteger timeOut = showTime+1;//倒计时+1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeOut<=0) {//倒计时结束
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%ld",timeOut] forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}
//移除广告页面
-(void)dismiss{
    
    [self.countTimer invalidate];
    self.countTimer = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.f;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
