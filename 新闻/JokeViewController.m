//
//  JokeViewController.m
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "JokeViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImage.h"
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
@interface JokeViewController ()



@end

@implementation JokeViewController
NSInteger updataNum =2;
#pragma Mark --- Uitableview和NSmutable数组
-(void)creatUItableView{
    
    _arrayContent = [[NSMutableArray alloc]init];
    _arrayTime = [[NSMutableArray alloc]init];
    _arrayImageUrl = [[NSMutableArray alloc]init];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-20) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}
#pragma Mark --- Uitableview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayContent.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellName = @"ID";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    
    //文本设置
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    cell.textLabel.text = _arrayContent[indexPath.row];
    cell.detailTextLabel.text = _arrayTime[indexPath.row];
    
    NSURL *imageURL = [_arrayImageUrl objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"load.jpg"]];
    //加载完成
    [self removeView];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIView *view = [[UIView alloc]init];
    view.frame = self.view.bounds;
    view.backgroundColor = [UIColor grayColor];
    view.tag = 101;
   
    UIImageView *imagview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 450)];
    
    NSString *str = [_arrayImageUrl objectAtIndex:indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:str];
    NSString *NS = [_arrayImageUrl objectAtIndex:indexPath.row];
    NSString *last = [NS substringFromIndex:NS.length -1]; //F -- GIF G --JPG
    
    if ([last isEqualToString:@"g"]) {
        [imagview sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"load.jpg"]];
        [view addSubview:imagview];
    }
    if ([last isEqualToString:@"f"]) {
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:data];
        FLAnimatedImageView *animatedImageView = [[FLAnimatedImageView alloc]init];
        animatedImageView.animatedImage = animatedImg;
        animatedImageView.frame = CGRectMake(0, 0, KScreenWidth, 200);
        [view addSubview:animatedImageView];
    }
     [self.view addSubview:view];
}
#pragma Mark --- 网络加载模块
-(void)startConentNetWork:(NSInteger )page{
    
    [self Prages];
    
    NSString *URL = [NSString stringWithFormat:@"http://api.avatardata.cn/Joke/NewstImg?key=7e0686a7992d4e77a90044bec3e376e0&page=%lu&rows=6",page];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:URL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self JSONToNSMutableArray:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"连接失败");
    }];
}
-(void)JSONToNSMutableArray:(NSDictionary *)dicdata{
    NSArray *arrdata = [dicdata objectForKey:@"result"];
    NSLog(@"arrdata = %@",arrdata);
    
    for (NSInteger i = 0; i<arrdata.count; i++) {
        NSDictionary *dic = [arrdata objectAtIndex:i];
        NSString *contents =[dic objectForKey:@"content"];
        [_arrayContent insertObject:contents atIndex:0];
        
        NSDictionary *time = [arrdata objectAtIndex:i];
        NSString *times = [time objectForKey:@"updatetime"];
        [_arrayTime insertObject:times atIndex:0];
        
        NSDictionary *image = [arrdata objectAtIndex:i];
        NSString *ImageURL = [image objectForKey:@"url"];
        [_arrayImageUrl insertObject:ImageURL atIndex:0];
        
    }
    [_tableView reloadData];
}
#pragma Mark --- 加载进度
-(void)Prages{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    [self.view addSubview:view];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicator setCenter:view.center];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [view addSubview:_indicator];
    [_indicator startAnimating];
}
-(void)removeView{
    [_indicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:108];
    [view removeFromSuperview];
}
#pragma Mark ---点击事件
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
}
#pragma Mark --- 处理函数

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
}
-(void)viewDidAppear:(BOOL)animated{
    [self creatUItableView];
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
