//
//  Domestic.m
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "Domestic.h"
#import "UIImageView+WebCache.h"
#import "DomesticModel.h"
#import "webViw.h"
#define KScreenH [UIScreen mainScreen].bounds.size.height
#define KScreenW [UIScreen mainScreen].bounds.size.width
#define MAINLABEL_TAG 1
#define SECONDLABEL_TAG 2
#define PHOTO_TAG 3
@interface Domestic ()

@end

@implementation Domestic
NSInteger page =1;
#pragma Mark --- 数据连接和解析
-(void)startConnect{
    
    NSString *domesNew = @"http://api.tianapi.com/guonei/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10&page=1";
    
    if (_session == nil) {
        _session =[AFHTTPSessionManager manager];
    }
    
    [_session GET:domesNew parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self AnalysisJson:responseObject];
        }else{
            NSLog(@"数据非NSDictionary类型,请查看返回类型");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"连接失败" message:@"请尝试刷新" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}
-(void)AnalysisJson:(NSDictionary *)response{
    NSArray *newslist = [response objectForKey:@"newslist"];
    for (NSInteger i=0; i<newslist.count; i++) {
        DomesticModel *model = [[DomesticModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_arrayTime insertObject:time atIndex:0];

        NSString *title = [alldic objectForKey:@"title"];
        [_arrayTitle insertObject:title atIndex:0];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL = url;
        [_arrayURL insertObject:model atIndex:0];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_picUrl insertObject:picUrl atIndex:0];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_description insertObject:descroption atIndex:0];
    }
    
    [_tableView reloadData];
    
}
#pragma Mark --- uitableview和初始化数据
-(void)creatUItableView{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH-20) style:UITableViewStylePlain];
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
    return _arrayTime.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName = @"ID";
    UILabel *mainLabel,*secondLabel;
    UIImageView *photo;
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellName];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 15)];
        mainLabel.tag = MAINLABEL_TAG;
        mainLabel.font = [UIFont systemFontOfSize:14];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:mainLabel];
        
        secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 220, 25)];
        secondLabel.tag = SECONDLABEL_TAG;
        secondLabel.font = [UIFont systemFontOfSize:12];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.textColor = [UIColor darkGrayColor];
        secondLabel.autoresizingMask =UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:secondLabel];
        
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(225, 0, 80, 45)];
        photo.tag = PHOTO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
    }else{
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAINLABEL_TAG];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:SECONDLABEL_TAG];
        photo = (UIImageView *)[cell.contentView viewWithTag:PHOTO_TAG];
    }
    
    NSString *source = @"来源:";
    NSString *Des = _description[indexPath.row];
    NSString *strTime = @"时间:";
    NSString *time = _arrayTime[indexPath.row];
    NSString *stitching = [NSString stringWithFormat:@"%@%@\t%@%@",source,Des,strTime,time];

    mainLabel.text = _arrayTitle[indexPath.row];
    mainLabel.numberOfLines =0;
    secondLabel.text = stitching;
    
    
     /* //提供测试 ----->API接口给的图有问题
     NSString *ceshi = @"http://api.avatardata.cn/Joke/Img?file=b1537858612749efa7c5ba3c9b688602.jpg";
    NSURL *URl =[NSURL URLWithString:ceshi];
    [photo sd_setImageWithURL:URl placeholderImage:[UIImage imageNamed:@"load.jpg"]];
     */
    
    /*
      API某一段
     {
     ctime = "2017-08-17 23:42";
     description = "\U641c\U72d0\U56fd\U5185";
     picUrl = "http://photocdn.sohu.com/20170817/Img507256209_ss.jpg";
     title = "\U5168\U56fd\U536b\U751f\U8ba1\U751f\U7cfb\U7edf\U8868\U5f70\U5927\U4f1a\U53ec\U5f00 \U4e60\U8fd1\U5e73\U4f5c\U51fa\U6307\U793a";
     url = "http://news.sohu.com/20170817/n507256418.shtml";
     }
     */
    [photo sd_setImageWithURL:_picUrl[indexPath.row] placeholderImage:[UIImage imageNamed:@"zuosi.jpg"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获得当前点击的URL
    DomesticModel *model = _arrayURL[indexPath.row];
    //传递给webView
    webViw *WV = [[webViw alloc]init];
    WV.URL = model.URL;
    [self presentViewController:WV animated:YES completion:nil];
}
#pragma Mark --- scrollView下拉刷新
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, KScreenW, 80)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(view.center.x-30, view.center.y+20, 60, 20)];
    label.text = @"正在刷新";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    [view addSubview:label];
    
    _indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicator setCenter:view.center];
    [_indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_indicator setColor:[UIColor redColor]];
    [view addSubview:_indicator];
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 350, KScreenW, 80)];
    view2.tag =101;
    _indicator2 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicator2 setCenter:view2.center];
    [_indicator2 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    //下拉刷新
    if (scrollView.contentOffset.y<-60) {
        [UIView animateWithDuration:1.0 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        }completion:^(BOOL finished) {
            [self.view addSubview:view];
            [_indicator startAnimating];
            
            _Refresh = [[NSThread alloc]initWithTarget:self selector:@selector(PullRefresh) object:nil];
            [_Refresh start];
            //设置延时时间为2秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    //恢复之前的contentInst，让greenView回到原来的地方
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    [_indicator stopAnimating];
                    [label removeFromSuperview];
                    [view removeFromSuperview];
                }];
            });
        }];
    }
    
    //上拉加载
    if (scrollView.bounds.size.height+scrollView.contentOffset.y>scrollView.contentSize.height-90) {
        [UIView animateWithDuration:1.0 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        }completion:^(BOOL finished) {
            [self.view addSubview:_indicator2];
            [_indicator2 startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    page++;
                    //调用上拉数据加载
                    [self upToRefresh:page];
                    
                }];
            });
        }];
    }
    
}
#pragma Mark --- 线程加载
-(void)PullRefresh{
    page++;
    //刷新函数
    [self PullDownToRefresh:page];
}
#pragma Mark ---下拉刷新函数
-(void)PullDownToRefresh:(NSInteger )page{
    NSString *https = [NSString stringWithFormat:@"http://api.tianapi.com/guonei/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10&page=%ld",page];
    
    if (_session == nil) {
        _session = [AFHTTPSessionManager manager];
    }
    
    [_session GET:https parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self pullAnalysisJson:responseObject];
        }else{
            NSLog(@"JSON数据错误，请联系后台或更换API接口");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"刷新失败" message:@"API接口有误，请联系制作人进行更改" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
#pragma Mark --- 上拉刷新数据
-(void)upToRefresh:(NSInteger)num
{
    if (_session == nil) {
        _session = [AFHTTPSessionManager manager];
    }
    if (num<60) {
        NSString *http = [NSString stringWithFormat:@"http://api.tianapi.com/guonei/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10&page=%ld",num];
        [_session GET:http parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               //调用上拉数据处理
            [self upAnilysisJson:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"刷新失败" message:@"API接口有误，请联系制作人进行更改" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"加载失败" message:@"已经是最底了" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
#pragma Mark --- 上拉刷新数据处理
-(void)upAnilysisJson:(NSDictionary *)response{
    NSArray *newslist = [response objectForKey:@"newslist"];
    
    for (NSInteger i=0; i<newslist.count; i++) {
        DomesticModel *model = [[DomesticModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_arrayTime addObject:time];
        
        NSString *title = [alldic objectForKey:@"title"];
        [_arrayTitle addObject:title];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL = url;
        [_arrayURL addObject:model];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_picUrl addObject:picUrl];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_description addObject:descroption];
    }
    [_tableView reloadData];
    [_indicator2 stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
}
#pragma Mark --- 下拉刷新数据处理
-(void)pullAnalysisJson:(NSDictionary *)response{
    NSArray *newslist = [response objectForKey:@"newslist"];
    
    for (NSInteger i=0; i<newslist.count; i++) {
        DomesticModel *model = [[DomesticModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_arrayTime insertObject:time atIndex:0];
        
        NSString *title = [alldic objectForKey:@"title"];
        [_arrayTitle insertObject:title atIndex:0];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL = url;
        [_arrayURL insertObject:model atIndex:0];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_picUrl insertObject:picUrl atIndex:0];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_description insertObject:descroption atIndex:0];
    }
    
    [_tableView reloadData];
}
#pragma Mark --- 数据初始化
-(void)arrayInit{
    _arrayTime = [[NSMutableArray alloc]init];
    _arrayURL = [[NSMutableArray alloc]init];
    _arrayTitle = [[NSMutableArray alloc]init];
    _picUrl = [[NSMutableArray alloc]init];
    _description = [[NSMutableArray alloc]init];
    
    _session = [AFHTTPSessionManager manager];
}
#pragma Mark --- 处理函数
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self arrayInit];
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
