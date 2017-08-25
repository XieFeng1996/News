//
//  ShowHot.m
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "ShowHot.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "webViw.h"
#define KScreenHeight self.view.frame.size.height
#define KScreenWidth  self.view.frame.size.width

#define CLog(format, ...)  NSLog(format, ## __VA_ARGS__)
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
@interface ShowHot ()

@end

@implementation ShowHot
#pragma Mark ---- 检索函数
-(void)RetrieveData:(NSString *)data{
    _NewsTitle.text = data;
    NSString *HTP = [NSString stringWithFormat:@"http://api.avatardata.cn/ActNews/Query?key=cc76ab3be49c42e8810cbd1842bfd49c&keyword=%@",data];
    
    HTP = [HTP stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:HTP parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self Analytical:responseObject];
        }else{
            _alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"数据错误" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [_alertView show];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
    }];

}
#pragma Mark ---- JSON解析
-(void)Analytical:(NSDictionary *)dicData{
    NSArray *array = [dicData objectForKey:@"result"];
    NSDictionary *arrayfirst = [array objectAtIndex:0];
    
    NSString *pdate = [arrayfirst objectForKey:@"pdate"];
    NSString *pdate_src = [arrayfirst objectForKey:@"pdate_src"];
    NSString *src = [arrayfirst objectForKey:@"src"];
    NSString *content = [arrayfirst objectForKey:@"content"];
    NSString *full_title = [arrayfirst objectForKey:@"full_title"];
    NSString *url = [arrayfirst objectForKey:@"url"];
    NSString *imageUrl = [arrayfirst objectForKey:@"img"];
    
    _SrcUrl = url;
    
    
    NSString *needCutChar = @"<em>";
    NSString *needCutChar2 = @"</em>";
    
    NSString *cut1 = [content stringByReplacingOccurrencesOfString:needCutChar withString:@""];
    NSString *cut2 = [cut1 stringByReplacingOccurrencesOfString:needCutChar2 withString:@""];
    NSString *cut3 = [cut2 stringByReplacingOccurrencesOfString:@"  " withString:@"\n"];//双空格换行
    
    
    NSString *time = [pdate stringByAppendingFormat:@"\t%@",pdate_src];
    
    NSString *HTPS = @"原网址：";
    NSString *URL = [HTPS stringByAppendingString:url];
    
    _NewsFull_Title.text = full_title;
    _NewsReadTime.text = time;
    _NewsSrc.text = src;
    _NewsURL.text = URL;
    _NewsText.text = cut3;
    
    //加载图片前判定
    if (imageUrl.length<=0) {
        //没图片
        [_NewsImage setImage:[UIImage imageNamed:@"NoImage.png"]];
        [_activityIndicator stopAnimating];
    }else{
        [_NewsImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"NoNet.jpg"]];
        [_activityIndicator stopAnimating];
    }
    
}
#pragma Mark ---- 视图切换处理
-(void)viewDidAppear:(BOOL)animated{
    [self crateDisplayDataImageView];
    [self RetrieveData:_HttpHard];
}
-(void)viewDidDisappear:(BOOL)animated{
    [_News removeFromSuperview];
}
#pragma Mark ---- 滑动界面处理
-(void)crateDisplayDataImageView{

    _NewsTitle = [[UILabel alloc]init];
    _NewsSrc = [[UILabel alloc]init];
    _NewsReadTime = [[UILabel alloc]init];
    _NewsFull_Title = [[UILabel alloc]init];
    _NewsText = [[UILabel alloc]init];
    _NewsImage = [[UIImageView alloc]init];
    _NewsURL = [[UILabel alloc]init];

    _News = [[UIScrollView alloc]init];
    
    NSInteger navHeight = self.navigationController.navigationBar.frame.size.height;
    NSInteger tabbarHeight = self.tabBarController.tabBar.frame.size.height;
    
    NSInteger VisualHeight = KScreenHeight - navHeight -tabbarHeight;
    
    _News.frame = CGRectMake(0,60, KScreenWidth, KScreenHeight);
    _News.scrollEnabled = YES;
    _News.contentSize = CGSizeMake(KScreenWidth, VisualHeight*1.5);
    _News.bounces = NO;
    _News.backgroundColor = [UIColor whiteColor];
    
    _NewsTitle.frame = CGRectMake(KScreenWidth/10-30, 0, KScreenWidth, 40);
    _NewsTitle.font = [UIFont systemFontOfSize:24];
    _NewsTitle.textAlignment = NSTextAlignmentCenter;
    
    _NewsFull_Title.frame = CGRectMake(0, 40, KScreenWidth, 30);
    _NewsFull_Title.font = [UIFont systemFontOfSize:12];
    _NewsFull_Title.textAlignment = NSTextAlignmentCenter;
    _NewsFull_Title.numberOfLines =2;
    
    _NewsReadTime.frame = CGRectMake(0, 65, KScreenWidth, 20);
    _NewsReadTime.font = [UIFont systemFontOfSize:8];
    _NewsReadTime.textColor = [UIColor grayColor];
    _NewsReadTime.textAlignment = NSTextAlignmentCenter;
    
    _NewsSrc.frame = CGRectMake(0, 75, KScreenWidth, 20);
    _NewsSrc.font = [UIFont systemFontOfSize:8];
    _NewsSrc.textColor = [UIColor grayColor];
    _NewsSrc.textAlignment = NSTextAlignmentRight;
    
    
    _NewsURL.frame = CGRectMake(0, 500, KScreenWidth, 30);
    _NewsURL.font = [UIFont systemFontOfSize:8];
    _NewsURL.textColor = [UIColor grayColor];
    _NewsURL.textAlignment = NSTextAlignmentLeft;
    _NewsURL.numberOfLines =0;
    
    _NewsText.frame = CGRectMake(0, 220, KScreenWidth, 300);
    _NewsText.font = [UIFont systemFontOfSize:12];
    _NewsText.textAlignment = NSTextAlignmentLeft;
    _NewsText.numberOfLines =0;
    
    _NewsImage.frame = CGRectMake(0,100, KScreenWidth, VisualHeight/2);
    _NewsImage.backgroundColor = [UIColor blueColor];
    
    _activityIndicator = [[UIActivityIndicatorView alloc]init];
    [_NewsImage addSubview:_activityIndicator];
    _activityIndicator.frame = CGRectMake((KScreenWidth-50)/2,VisualHeight/4,30,30);
    _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [_activityIndicator startAnimating];
    
    _Jump = [[UIBarButtonItem alloc]initWithTitle:@"详细内容" style:UIBarButtonItemStylePlain target:self action:@selector(JumpToURL)];
    self.navigationItem.rightBarButtonItem = _Jump;

    
    [_News addSubview:_NewsTitle];
    [_News addSubview:_NewsFull_Title];
    [_News addSubview:_NewsReadTime];
    [_News addSubview:_NewsImage];
    [_News addSubview:_NewsSrc];
    [_News addSubview:_NewsURL];
    [_News addSubview:_NewsText];
    
    [self.view addSubview:_News];
}
#pragma Mark --- 跳转到webView上
-(void)JumpToURL{
    webViw *WV = [[webViw alloc]init];
    WV.URL =_SrcUrl;
    [self.navigationController pushViewController:WV animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
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
