//
//  AdvertiseViewController.m
//  新闻
//
//  Created by 谢风 on 2017/8/25.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "AdvertiseViewController.h"

@interface AdvertiseViewController ()

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation AdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Bilibili";
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor whiteColor];
    if (!self.adURL) {
        self.adURL = @"https://www.bilibili.com";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adURL]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
-(void)setAdURL:(NSString *)adURL{
    _adURL = adURL;
}


@end
