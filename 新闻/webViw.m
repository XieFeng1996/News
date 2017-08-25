//
//  webViw.m
//  新闻
//
//  Created by 谢风 on 2017/8/11.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "webViw.h"

@interface webViw ()

@end

@implementation webViw
#pragma Mark --- 设置webView
-(void)setWebView{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_webView];
}

#pragma Mark --- 前往原网址
-(void)goToOriginalURL{
    NSURL *URL = [NSURL URLWithString:_URL];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    /*************------------------*************
     不想用原因：部分web加载太慢☟
     *************------------------*************/
    _webView.delegate = self;
    [_webView loadRequest:request];
}
#pragma Mark --- UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicatorView setCenter:view.center];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_indicatorView];
    
    [_indicatorView startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_indicatorView stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [_indicatorView stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
#pragma Mark --- 创建button
-(void)creatButton{
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-80, 0,80, 20);
    [_button setTitle:@"Back" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
}
-(void)buttonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma Mark --- 处理工作
-(void)viewDidAppear:(BOOL)animated{
    [self setWebView];
    [self goToOriginalURL];
    [self creatButton];
 
}
-(void)viewDidDisappear:(BOOL)animated{
    [_webView removeFromSuperview];
    _URL =nil;
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
