//
//  MYView.m
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "MYView.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#define ImageCount 5
#define NavigationHeight self.navigationController.navigationBar.frame.size.height
#define ViewHeight       self.view.frame.size.height
#define ViewWidth        self.view.frame.size.width
@interface MYView ()

@end

@implementation MYView
BOOL isLogin = false;
#pragma Mark  --- 轮播图
-(void)creatScrollViewImage{
    
    _scroll = [[UIScrollView alloc]init];
    _scroll.frame =CGRectMake(0, NavigationHeight, ViewWidth, 200);
    _scroll.pagingEnabled =YES;
    _scroll.bounces =NO;
    _scroll.backgroundColor = [UIColor grayColor];
    _scroll.contentSize = CGSizeMake(ViewWidth*ImageCount, 200);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator =NO;
    _scroll.userInteractionEnabled = YES;
    _scroll.scrollEnabled =YES;
    _scroll.delegate =self;
    
    for (int i =0; i<ImageCount; i++) {
        NSString *ImageName = [NSString stringWithFormat:@"P%d.jpg",i+1];
        UIImage *image = [UIImage imageNamed:ImageName];
        UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
        imageview.frame = CGRectMake(ViewWidth*i,0,ViewWidth, 200);
        [_scroll addSubview:imageview];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_scroll];
    
}
-(void)creatPageControl{
    _page = [[UIPageControl alloc]initWithFrame:CGRectMake(ViewWidth-80, NavigationHeight+180, 60, 20)];
    _page.pageIndicatorTintColor = [UIColor whiteColor];
    _page.currentPageIndicatorTintColor = [UIColor grayColor];
    _page.enabled = YES;
    _page.currentPage = 0;
    _page.numberOfPages = ImageCount;
    [self.view addSubview:_page];
    
    [self addTimer];
    
}
-(void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)nextImage{

    CGPoint offset = _scroll.contentOffset;
    NSInteger currentPage = _page.currentPage;
    
    if (currentPage == 4) {
        currentPage =0;
        offset = CGPointZero;
        [_scroll setContentOffset:offset animated:YES];
    }else{
        currentPage++;
        offset.x += self.view.bounds.size.width;
        [_scroll setContentOffset:offset animated:YES];
    }

    _page.currentPage = currentPage;
    
}
#pragma Mark  --- UIScrollView协议
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer invalidate];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat scrollViews = scrollView.frame.size.width;
    CGFloat X = scrollView.contentOffset.x;
    NSInteger page = (X+scrollViews/2)/scrollViews;
    _page.currentPage = page;
    
    [self addTimer];
}

#pragma Mark  --- tableView相关
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationHeight+200,ViewWidth, 280) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //去掉原生分割线
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self creatNSMutableViewData];
    
}
-(void)creatNSMutableViewData{
    _arrayData = [[NSMutableArray alloc]init];
    NSArray *Array = [NSArray arrayWithObjects:@"登陆",@"检查更新",@"关于",@"供享直播",@"退出",nil];
    [_arrayData addObjectsFromArray:Array];

    [_tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger IndexHeight = _tableView.frame.size.height/_arrayData.count;
    return IndexHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"ID";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *strImage = [NSString stringWithFormat:@"D%ld.png",indexPath.row%5];
    UIImage *image = [UIImage imageNamed:strImage];
    cell.imageView.image = image;
   
    if (indexPath.row==1) {
        cell.detailTextLabel.text = @"v1.0.0.2<更新版本>";
    }
    
    if(indexPath.row ==3){
        
        cell.detailTextLabel.textColor =[UIColor redColor];
        cell.detailTextLabel.text =@"敢想敢播，有Fun有态度";
        
    }
    
    cell.textLabel.text =_arrayData[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if(isLogin ==false){
            //登陆
            [self alertController:5];
        }else{
            [self pushAlertController:@"登陆失败" andMessage:@"你已经登陆过了，请不要重复登陆。"];
        }
        
    }else if (indexPath.row == 1){
        //检查更新
        AFHTTPSessionManager *session =[AFHTTPSessionManager manager];
        [session GET:@"http://api.avatardata.cn/GuoNeiNews/Query?key=68f3d7bfeeef466b89119e460c331618&page=1&rows=10" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject = %@",responseObject);
            [self DealWith:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else if (indexPath.row == 2){
        //关于
        [self alertController:2];
    }else if (indexPath.row == 3){
        //供享直播
        [self SafariConnentURL];
    }else if (indexPath.row == 4){
        //退出
        [self creatAlertView];
    }
    
}
#pragma Mark  --- JSON处理
-(void)DealWith:(NSDictionary *)dicData{
    NSString *strCode = [dicData objectForKey:@"error_code"];
    NSInteger Code = [strCode integerValue];
    [self alertController:Code];
}
#pragma Mark  --- 提示框
-(void)alertController:(NSInteger )Code{
    if (Code == 0) {
        [self pushAlertController:@"版本信息" andMessage:@"当前已经是最新版本"];
    }else if(Code ==1){
        [self pushAlertController:@"版本信息" andMessage:@"当前不是最新版本,请前往AppStore下载"];
    }else if(Code ==2){
        [self pushAlertController:@"相关信息" andMessage:@"制作人：Pyrrha\nAPI提供方:阿凡达数据\t天行数据"];
    }else{
        //跳转登陆界面
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
#pragma Mark  --- 响应按钮版本预告
-(void)MY{
    [self pushAlertController:@"版本预知" andMessage:@"当前界面下一个版本将使用抽屉形式"];
}
#pragma Mark  --- 弹出提示框
-(void)pushAlertController:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}
#pragma Mark  --- 处理
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *img = [[UIImage imageNamed:@"个人.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:img tag:4];
    
    self.tabBarItem = tabBarItem;
    self.navigationItem.title = @"设置";
    
    [self creatScrollViewImage];
    [self creatPageControl];
}
#pragma Mark  --- 退出当前APP
-(void)creatAlertView{
    _alert = [[UIAlertView alloc]initWithTitle:@"" message:@"要关闭这个APP吗？" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [_alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self exitApplication];
    }
}
-(void)exitApplication{
    AppDelegate *App = [UIApplication sharedApplication].delegate;
    UIWindow *window = App.window;
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha =0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

#pragma Mark  --- 调用浏览器访问网址
-(void)SafariConnentURL{
    NSURL *url = [NSURL URLWithString:@"http://www.gxzb.tv"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication]openURL:url];
    }else{
        _alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"Safari呢?" delegate:self cancelButtonTitle:@"重新安装" otherButtonTitles:@"不装", nil];
        [_alert show];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [self creatTableView];
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
