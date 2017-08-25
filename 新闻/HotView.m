//
//  HotView.m
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "HotView.h"
#import "AFNetworking.h"
#import "ShowHot.h"
#import "webViw.h"
#import "AdvertiseViewController.h"
@interface HotView ()

@end

@implementation HotView
#pragma Mark --- API接口连接
-(void)ConnectToTheServer{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:@"http://api.avatardata.cn/ActNews/LookUp?key=cc76ab3be49c42e8810cbd1842bfd49c" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self ParseData:responseObject];
        }else{
            NSLog(@"下载对象不是NSDictionary类型");
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"连接失败");
        _alertView = [[UIAlertView alloc]initWithTitle:@"连接失败" message:@"服务器连接失败......" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alertView show];
    }];
}
#pragma Mark --- JS数据处理
-(void)ParseData:(NSDictionary *)dicData{
    NSArray *result = [dicData objectForKey:@"result"];
    NSInteger resultcount = result.count;
    
    
    _mutableArray = [[NSMutableArray alloc]init];
    _ArrayData = [[NSMutableArray alloc]init];
    
    for (int i= 0; i<10; i++) {
        NSString *conts = [result objectAtIndex:i];
        [_mutableArray addObject:conts];
    }
    
    for (int j=10; j<resultcount; j++) {
        NSString *noSee = [result objectAtIndex:j];
        [_ArrayData addObject:noSee];
    }
    
    [_table reloadData];
}
#pragma Mark --- UITableView协议
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _mutableArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *news = @"news";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:news];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:news];
    }
    
    cell.textLabel.text = _mutableArray[indexPath.row];

    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中的单元格行数:%ld",indexPath.row);
    NSString *title = [_mutableArray objectAtIndex:indexPath.row];
    //发送检索数据
    [self LoadTheSearchData:title];
}
#pragma Mark --- UITableView视图创建
-(void)creatUITableView{
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.delegate =self;
    _table.dataSource =self;
    _table.bounces =NO;
    _table.showsVerticalScrollIndicator = NO;
    [_rightView addSubview:_table];
    

    _btnLoadData = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pressLoad)];
    self.navigationItem.rightBarButtonItem = _btnLoadData;
    
    _showHot = [[ShowHot alloc]init];
}

#pragma Mark --- 数组处理，第一个数组用于显示，第二个数组用于记录总的数组
-(void)pressLoad{
   
    static int  i =10;
    
    if (i<40) {
        for ( int j=0; j<10;j++,i++) {
            
            NSString *Index = [[NSString alloc]init];
            Index = [_ArrayData objectAtIndex:i];
            [_mutableArray insertObject:Index atIndex:0];
        }
    }else{
        _alertView = [[UIAlertView alloc]initWithTitle:@"加载完成" message:@"今日资讯热点全部加载完成了" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [_alertView show];
    }
   
    [_table reloadData];
    
}
#pragma Mark --- 检索数据
//检索数据，根据传进来的值进行检索(将检索的文字发送过去)
-(void)LoadTheSearchData:(NSString *)Data{
    /**********---------------------------**********
     
     使用的API接口有问题，所以添加一个webView用于跳转获取完整的数据
     
     **********---------------------------**********/
     
   _showHot.HttpHard =Data;
    [self.navigationController pushViewController:_showHot animated:YES];
}
#pragma Mark --- 抽屉效果
-(void)creatScrollview{
    _scroll= [[UIScrollView alloc]init];
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    
    _scroll.frame = CGRectMake(0,0,self.view.frame.size.width,520);
    _scroll.contentSize = CGSizeMake(self.view.frame.size.width+100, 0);
    _scroll.contentOffset = CGPointMake(100, 0);
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.delegate = self;
    
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100,_scroll.frame.size.height)];
    _leftView.backgroundColor = [UIColor grayColor];
    [_scroll addSubview:_leftView];
    
    _rightView = [[UIView alloc]initWithFrame:CGRectMake(100, 0,_scroll.frame.size.width,_scroll.frame.size.height)];
    _rightView.backgroundColor = [UIColor orangeColor];
    [_scroll addSubview:_rightView];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat xy = scrollView.contentOffset.x/_leftView.frame.size.width;
    //0.85+0.15*xy = 最小缩放尺寸+滑动控制的缩放尺寸
    _rightView.transform = CGAffineTransformMakeScale(0.85+0.15*xy, 0.85+0.15*xy);
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGFloat leftViewWidth = _leftView.frame.size.width;
    if (scrollView.contentOffset.x < leftViewWidth*0.3) {
        [UIView animateWithDuration:0.3 animations:^{
            scrollView.contentOffset = CGPointMake(0, 0);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            //复原
            scrollView.contentOffset = CGPointMake(leftViewWidth, 0);
        }];
    }
}
#pragma Mark --- 给左边加点东西
-(void)addLeftViewSome{
    
    UIImage *image = [UIImage imageNamed:@"coco@2x.jpg"];
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [imageview1 setImage:image];
    [_leftView addSubview:imageview1];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,44, 100, 30)];
    label.text = @"网址导航";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [_leftView addSubview:label];
    
    NSArray *btnTitle = [NSArray arrayWithObjects:@"腾讯",@"搜狐",@"网易",@"央视",nil];
    
    for (NSInteger i=0; i<btnTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 74+70*i, 100, 40);
        
        [btn setTitle:btnTitle[i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.tag = 101+i;
        [_leftView addSubview:btn];
    }
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 74+70*btnTitle.count, 100, 30)];
    label2.text = @"某辣鸡卡牌游戏";
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [_leftView addSubview:label2];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100+70*btnTitle.count, 100, 145)];
    UIImage *image2 = [UIImage imageNamed:@"Lcon60@3x.png"];
    imageview.image = image2;
    [_leftView addSubview:imageview];
    
}
-(void)btnClick:(UIButton *)btn{
    NSInteger Tag = btn.tag;
    webViw *WV = [[webViw alloc]init];
    NSString *QQ = @"http://www.qq.com";
    NSString *sohu = @"http://www.sohu.com";
    NSString *wangyi = @"http://www.163.com";
    NSString *cctv = @"http://www.cctv.com";
    switch (Tag) {
        case 101:
            WV.URL = QQ;
            break;
        case 102:
            WV.URL = sohu;
            break;
        case 103:
            WV.URL = wangyi;
            break;
        case 104:
            WV.URL = cctv;
            break;
        default:
            break;
    }
   [self.navigationController pushViewController:WV animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImage *img = [[UIImage imageNamed:@"hot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tab = [[UITabBarItem alloc]initWithTitle:@"资讯热点" image:img tag:2];
    
    self.tabBarItem =tab;
    self.navigationItem.title =@"资讯热点";
    
    [self creatScrollview];
    [self addLeftViewSome];
    
    [self creatUITableView];
    
    [self ConnectToTheServer];
    
    //广告点击效果
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
}
-(void)pushToAd{
    AdvertiseViewController *advc = [[AdvertiseViewController alloc]init];
    [self.navigationController pushViewController:advc animated:YES];
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
