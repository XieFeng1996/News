//
//  TravelViewController.m
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "TravelViewController.h"
#import "UIImageView+WebCache.h"
#import "TravelModel.h"
#import "webViw.h"
#define KSh [UIScreen mainScreen].bounds.size.height
#define KSw  [UIScreen mainScreen].bounds.size.width
#define MAI_TAG 1
#define SEC_TAG 2
#define PHO_TAG 3
@interface TravelViewController ()

@end

@implementation TravelViewController
NSInteger TravelPage =1;
#pragma Mark --- 开始函数
-(void)TravelstartContent{
    //初始化函数
    [self InterInit];
    NSString *strpage = [NSString stringWithFormat:@"http://api.tianapi.com/travel/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10"];
    [_Travesession GET:strpage parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //调用初始化函数处理 --->因为返回的数据时json，所以懒的做判断了
        
        [self firstAnalyisJson:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"连接失败" message:@"请尝试刷新" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
#pragma Mark --- UITableview
-(void)creatUItableView{
    _TraveView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSw, KSh-20) style:UITableViewStylePlain];
    _TraveView.backgroundColor = [UIColor whiteColor];
    _TraveView.delegate = self;
    _TraveView.dataSource = self;
    [self.view addSubview:_TraveView];
}
#pragma Mark --- Uitableview协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _TraveTitle.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UILabel *mainLabel,*secondLabel;
    UIImageView *photo;
    static NSString *cellName = @"ID";
    UITableViewCell *cell = [_TraveView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 15)];
        mainLabel.tag = MAI_TAG;
        mainLabel.font = [UIFont systemFontOfSize:14];
        mainLabel.textAlignment = NSTextAlignmentLeft;
        mainLabel.textColor = [UIColor blackColor];
        mainLabel.numberOfLines = 0;
        mainLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:mainLabel];
        
        secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 220, 25)];
        secondLabel.tag = SEC_TAG;
        secondLabel.font = [UIFont systemFontOfSize:12];
        secondLabel.textAlignment = NSTextAlignmentRight;
        secondLabel.textColor = [UIColor darkGrayColor];
        secondLabel.autoresizingMask =UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:secondLabel];
        
        photo = [[UIImageView alloc]initWithFrame:CGRectMake(225, 0, 80, 45)];
        photo.tag = PHO_TAG;
        photo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:photo];
    }else{
        mainLabel = (UILabel *)[cell.contentView viewWithTag:MAI_TAG];
        secondLabel = (UILabel *)[cell.contentView viewWithTag:SEC_TAG];
        photo = (UIImageView *)[cell.contentView viewWithTag:PHO_TAG];
    }
    
    mainLabel.text = _TraveTitle[indexPath.row];
    
    NSString *source = @"来源:";
    NSString *time = @"时间:";
    NSString *description = _Travedescription[indexPath.row];
    NSString *cTime = _TraveTime[indexPath.row];
    NSString *output = [NSString stringWithFormat:@"%@%@\t%@%@",source,description,time,cTime];
    secondLabel.text = output;
    
    [photo sd_setImageWithURL:_TravepicUrl[indexPath.row] placeholderImage:[UIImage imageNamed:@"zuosi.jpg"]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获得当前点击的URL
    TravelModel *model = _TraveURL[indexPath.row];
    //传递给webView
    webViw *WV = [[webViw alloc]init];
    WV.URL = model.URL;
    [self presentViewController:WV animated:YES completion:nil];
}
#pragma Mark --- 下拉刷新
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, KSw, 80)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(view.center.x-30, view.center.y+20, 60, 20)];
    label.text = @"正在刷新";
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    [view addSubview:label];
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 350, KSw, 80)];
    
    _Traveindicator2 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_Traveindicator2 setCenter:view2.center];
    [_Traveindicator2 setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    _Traveindicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_Traveindicator setCenter:view.center];
    [_Traveindicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_Traveindicator setColor:[UIColor redColor]];
    [view addSubview:_Traveindicator];
    //下拉刷新
    if (scrollView.contentOffset.y<-60) {
        [UIView animateWithDuration:1.0 animations:^{
            scrollView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        }completion:^(BOOL finished) {
            [self.view addSubview:view];
            [_Traveindicator startAnimating];
            //设置延时时间为2秒
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    //恢复之前的contentInst，让greenView回到原来的地方
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    //下拉申请连接数据
                    TravelPage++;
                    [self PullDownToRefresh:TravelPage];
                    [_Traveindicator stopAnimating];
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
            [self.view addSubview:_Traveindicator2];
            [_Traveindicator2 startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 animations:^{
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    TravelPage++;
                    //调用上拉数据加载
                    [self upToRefresh:TravelPage];
                    [_Traveindicator2 stopAnimating];
                    [view2 removeFromSuperview];
                }];
            });
        }];
    }
}
#pragma Mark ---下拉刷新函数
-(void)PullDownToRefresh:(NSInteger )page{
    NSString *https = [NSString stringWithFormat:@"http://api.tianapi.com/travel/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10&page=%ld",page];
    
    if (_Travesession == nil) {
        _Travesession = [AFHTTPSessionManager manager];
    }
    
    [_Travesession GET:https parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    if (_Travesession == nil) {
        _Travesession = [AFHTTPSessionManager manager];
    }
    if (num<60) {
        NSString *http = [NSString stringWithFormat:@"http://api.tianapi.com/travel/?key=bc2b1b37f98a7256e323175d0e01df6d&num=10&page=%ld",num];
        [_Travesession GET:http parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        TravelModel *model = [[TravelModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_TraveTime addObject:time];
        
        NSString *title = [alldic objectForKey:@"title"];
        [_TraveTitle addObject:title];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL = url;
        [_TraveURL addObject:model];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_TravepicUrl addObject:picUrl];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_Travedescription addObject:descroption];
    }
    [_TraveView reloadData];
}
#pragma Mark --- 下拉刷新数据处理
-(void)pullAnalysisJson:(NSDictionary *)response{
    NSArray *newslist = [response objectForKey:@"newslist"];
    for (NSInteger i=0; i<newslist.count; i++) {
        TravelModel *model = [[TravelModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_TraveTime insertObject:time atIndex:0];
        
        NSString *title = [alldic objectForKey:@"title"];
        [_TraveTitle insertObject:title atIndex:0];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL =url;
        [_TraveURL insertObject:model atIndex:0];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_TravepicUrl insertObject:picUrl atIndex:0];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_Travedescription insertObject:descroption atIndex:0];
    }
    
    [_TraveView reloadData];
}
#pragma Mark --- 第一次进入处理
-(void)firstAnalyisJson:(NSDictionary *)dic{
    NSArray *newslist = [dic objectForKey:@"newslist"];
    for (NSInteger i=0; i<newslist.count; i++) {
        TravelModel *model = [[TravelModel alloc]init];
        NSDictionary *alldic = [newslist objectAtIndex:i];
        NSString *time = [alldic objectForKey:@"ctime"];
        [_TraveTime insertObject:time atIndex:0];
        
        NSString *title = [alldic objectForKey:@"title"];
        [_TraveTitle insertObject:title atIndex:0];
        
        NSString *url = [alldic objectForKey:@"url"];
        model.URL = url;
        [_TraveURL insertObject:model atIndex:0];
        
        NSString *picUrl = [alldic objectForKey:@"picUrl"];
        [_TravepicUrl insertObject:picUrl atIndex:0];
        
        NSString *descroption = [alldic objectForKey:@"description"];
        [_Travedescription insertObject:descroption atIndex:0];
    }
    
    [_TraveView reloadData];
}
#pragma Mark --- 初始化函数
-(void)InterInit{
    _TraveTitle = [[NSMutableArray alloc]init];
    _TraveTime = [[NSMutableArray alloc]init];
    _TraveURL = [[NSMutableArray alloc]init];
    _TravepicUrl = [[NSMutableArray alloc]init];
    _Travedescription = [[NSMutableArray alloc]init];
    
    _Travesession = [AFHTTPSessionManager manager];
}
#pragma Mark --- 处理函数
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blueColor];
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
