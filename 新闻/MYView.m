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
//圆角绘制(将要显示的时候调用这个方法) ----->扁平化以后没了
/*
  本质就是修改背景View，view的layer层自己分局cell的类型（顶、底和中间）来绘制
 */
/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 6.0f;//圆角大小
        cell.backgroundColor = [UIColor clearColor];
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 10, 0);
        BOOL addLine = NO;
        
        if (indexPath.row == 0&&indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        }else if (indexPath.row == 0){
            //最顶端的cell(两个向下圆弧和一条线)
            CGPathMoveToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxX(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.row]-1){
            //最低端的cell（两个向上的圆弧和一条线）
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        }else{
            //中间的cell
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor whiteColor].CGColor;//cell的填充颜色
        layer.strokeColor = [UIColor lightGrayColor].CGColor;//cell的边框颜色
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc]init];
            CGFloat lineHeight  = (1.f/[UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
            lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;//绘制中间间隔颜色
            [layer addSublayer:lineLayer];
        }
        UIView *bgView = [[UIView alloc]initWithFrame:bounds];
        [bgView.layer insertSublayer:layer atIndex:0];
        bgView.backgroundColor = [UIColor clearColor];
        cell.backgroundView = bgView;
    }
}*/
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"ID";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *strImage = [NSString stringWithFormat:@"A%ld.png",indexPath.row%5];
    UIImage *image = [UIImage imageNamed:strImage];
    cell.imageView.image = image;
   
    if (isLogin) {
        if (indexPath.row ==0) {
            cell.imageView.image = [UIImage imageNamed:@"coco@2x.jpg"];
        }
    }
    
    if (indexPath.row==1) {
        cell.detailTextLabel.text = @"v1.0.0.1";
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

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登陆" message:@"请输入你的账户密码" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSArray *textfields =alert.textFields;
            UITextField *namefield = textfields[0];
            UITextField *passwordfield = textfields[1];
            
            //模拟登陆操作
            if (_FMDB !=nil) {
                BOOL isOpen = [_FMDB open];
                if (isOpen) {
                    NSLog(@"打开成功");
                    NSString *Query = @"select *from figues;";
                    FMResultSet *result = [_FMDB executeQuery:Query];
                    NSString *SQlistName;
                    NSString *SQlistPassword;
                    while ([result next]) {
                        SQlistName = [result stringForColumn:@"name"];
                        SQlistPassword = [result stringForColumn:@"password"];
                    }
                    
                    NSString *name = [[NSString alloc]initWithString:namefield.text];
                    NSString *password = [[NSString alloc]initWithString:passwordfield.text];
                    
                    if([name isEqualToString:SQlistName]&[password isEqualToString:SQlistPassword]){
                        [self pushAlertController:@"登陆成功" andMessage:@"模拟登陆成功"];
                        //self.title = @"Pyrrha";
                        UIBarButtonItem *MY = [[UIBarButtonItem alloc]initWithTitle:@"版本预告" style:UIBarButtonItemStylePlain target:self action:@selector(MY)];
                        self.navigationItem.rightBarButtonItem = MY;
                        isLogin = true;
                        [_tableView reloadData];
                    }else{
                        [self pushAlertController:@"登陆失败" andMessage:@"请检查登陆账号或密码\n<正确账号:Pyrrha\n正确密码:12345678>"];
                    }
                }
            }else{
                NSLog(@"数据库出问题了！");
            }
            
        }]];
        //添加文本框
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder =@"name";
            textField.textColor = [UIColor blackColor];
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.textColor = [UIColor blackColor];
            textField.secureTextEntry = YES;
            textField.placeholder =@"Password";
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            textField.borderStyle = UITextBorderStyleRoundedRect;
        }];
        [self presentViewController:alert animated:YES completion:nil];
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
#pragma Mark  --- 数据库相关
-(void)creatSqLite{
    //表路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    //文件路径
    NSString *filePath = [documentsPath stringByAppendingString:@"Login.sqlite"];
    
    //实例化FMDB对象
    _FMDB = [FMDatabase databaseWithPath:filePath];
    
    [_FMDB open];
    
    //初始化数据表
    NSString *userInfo = @"create table if not exists figues(id interger primary key,name varchar(20),password varchar(20));";
    [_FMDB executeUpdate:userInfo];

    NSString *strQuery = @"select *from figues;";
    FMResultSet *result = [_FMDB executeQuery:strQuery];
    while ([result next]) {
         NSInteger figuesID =[result intForColumn:@"id"];
        if (figuesID == 1) {
            //NSLog(@"不操作");
            return;
        }else{
            NSString *Info = @"insert into figues values(1,'Pyrrha','12345678');";
            [_FMDB executeUpdate:Info];
        }
    }
    //安全起见
    [_FMDB close];
    
}
#pragma Mark  --- 处理
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *img = [[UIImage imageNamed:@"MY"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:img tag:3];
    
    self.tabBarItem = tabBarItem;
    self.navigationItem.title = @"设置";
    
    [self creatScrollViewImage];
    [self creatPageControl];
    [self creatSqLite];
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
