//
//  SearchView.m
//  新闻
//
//  Created by 谢风 on 2017/8/22.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "SearchView.h"
#import "AFNetworking.h"
#import "SearchManger.h"
#import "SearchModel.h"
#import "UIImageView+WebCache.h"
#import "webViw.h"
#define width self.view.frame.size.width
#define height self.view.frame.size.height
@interface SearchView ()

@end

@implementation SearchView
#pragma Mark ---搜索、view、tableview创建
-(void)creatSearch{
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.frame = CGRectMake(0, 0,width, 40);
    _searchBar.showsCancelButton =YES;
    _searchBar.tintColor = [UIColor orangeColor];
    _searchBar.placeholder = @"请搜索你想知道的新闻或者人物";
    //键盘类型
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
}
-(void)creatView{
    
    _view = [[UIView alloc]init];
    _view.frame = CGRectMake(0, 0,width, height);
    _view.backgroundColor = [UIColor grayColor];
    _view.alpha =0.3;
    
    _indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_indicatorView setCenter:_view.center];
    [_indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_view addSubview:_indicatorView];
}
-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40,width, 200)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,240, width, 30)];
    label.text = @"搜索结果";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    _downView = [[UITableView alloc]initWithFrame:CGRectMake(0, 280,width,height-280)];
    _downView.backgroundColor = [UIColor brownColor];
    _downView.delegate = self;
    _downView.dataSource = self;
    _downView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _historyData = [[NSArray alloc]init];
    _ResultData = [[NSMutableArray alloc]init];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_downView];
}
#pragma Mark --- tableView协议
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_tableView]) {
        if (section == 0) {
            if (_historyData.count>0) {
                return _historyData.count+2;
            }else{
                return 1;
            }
        }else{
            return 0;
        }
    }else if ([tableView isEqual:_downView]){
        return _ResultData.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableView]) {
        _tableView.estimatedRowHeight = 44.0f;
        return UITableViewAutomaticDimension;
    }
    if ([tableView isEqual:_downView]){
        return 100;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if ([tableView isEqual:_tableView]) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        if (indexPath.section ==0) {
            if (indexPath.row ==0) {
                cell.textLabel.text =@"历史记录";
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
            }else if (indexPath.row == _historyData.count+1){
                cell.textLabel.text = @"清除历史记录";
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                
            }else{
                NSArray *reversedArray = [[_historyData reverseObjectEnumerator]allObjects];
                cell.textLabel.text = reversedArray[indexPath.row-1];
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                cell.textLabel.textColor = [UIColor blackColor];
            }
        }
        //return cell;
    }else if ([tableView isEqual:_downView]){
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
        }
        SearchModel *model =_ResultData[indexPath.row];
        cell.textLabel.text = model.SearchTitle;
        cell.textLabel.numberOfLines =0;
        cell.textLabel.font = [UIFont systemFontOfSize:10];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.text = model.SearchFull_Title;
        cell.detailTextLabel.numberOfLines =0;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:8];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        NSString *imagURl = model.SearchImg;
        NSURL *url = [NSURL URLWithString:imagURl];
        
        cell.imageView.frame =CGRectMake(0, 0, 100, 80);
        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"load.jpg"]];
    }
    return cell;
}
#pragma Mark --- 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_searchBar resignFirstResponder]; //回收键盘
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:_tableView]) {
        NSMutableArray *Reverse = [[NSMutableArray alloc]init];
        for (NSInteger i = _historyData.count-1; i>=0; i--) {
            [Reverse addObject:_historyData[i]];
        }
        
        if (indexPath.row == _historyData.count+1) {//清除历史记录
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除历史记录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                [SearchManger removeAllArray];
                _historyData=nil;
                [_tableView reloadData];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            //访问网址
            NSString *index_str = Reverse[indexPath.row-1];
            [self serachRequestConnet:index_str];
        }
    }
   
    if ([tableView isEqual:_downView]) {
        NSLog(@"点击");
        //获得当前点击的URL
        SearchModel *model = _ResultData[indexPath.row];
        NSLog(@"当前点击的行数URL=%@",model.URL);
        //传递给webView
        webViw *WV = [[webViw alloc]init];
        WV.URL = model.URL;
        [self presentViewController:WV animated:YES completion:nil];
    }
}
#pragma Mark ---搜索执行回调方法
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>20) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"字数不能超过20" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
        [_searchBar setText:[searchText substringToIndex:20]];
    }
}
#pragma Mark --- 关闭搜索窗口
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma Mark --- 键盘上搜索事件的响应
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length>0&&![searchBar.text isEqual:@" "]) {
        [SearchManger SearchText:searchBar.text];
        [self readNSUserDefaults];
    }else{
        //不做任何处理
    }
    [_indicatorView startAnimating];
    [self.view addSubview:_view];
    //连接搜索
    [self serachRequestConnet:searchBar.text];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_indicatorView stopAnimating];
        [_view removeFromSuperview];
    });
    
}
#pragma Mark --- 连接函数
-(void)serachRequestConnet:(NSString *)text{
    NSString *url_String = [NSString stringWithFormat:@"http://api.avatardata.cn/ActNews/Query?key=cc76ab3be49c42e8810cbd1842bfd49c&keyword=%@",text];
    NSString *url_UTF8 = [url_String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:url_UTF8 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        _indicatorView2 = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(width/2-50, height/2, 50, 50)];
        _indicatorView2.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self.view addSubview:_indicatorView2];
        [_indicatorView2 startAnimating];
        //数据解析
        [self JSONAnilisity:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搜索失败" message:@"请尝试重新搜索" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
#pragma Mark --- 数据解析
-(void)JSONAnilisity:(NSDictionary *)respones{
    NSArray *result = [respones objectForKey:@"result"];
    
    if (_ResultData.count>0) {
       [_ResultData removeAllObjects];
    }
    for (NSInteger i =0; i<result.count; i++) {
        NSDictionary *allData = [result objectAtIndex:i];
        
        NSString *title = [allData objectForKey:@"title"];
        SearchModel *model = [[SearchModel alloc]init];
        model.SearchTitle = title;
    
        NSString *full_title = [allData objectForKey:@"full_title"];
        model.SearchFull_Title = full_title;
        
        NSString *img = [allData objectForKey:@"img"];
        model.SearchImg = img;
        
        NSString *url = [allData objectForKey:@"url"];
        model.URL = url;
        [_ResultData addObject:model];
    }
    
    [_downView reloadData];
    [_indicatorView2 stopAnimating];
}
#pragma Mark --- 搜索记录本地化
-(void)readNSUserDefaults{
    //取出缓存数据
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *historyArray = [userDefaultes arrayForKey:@"history"];
    NSLog(@"historyArray = %@",historyArray);
    _historyData = historyArray;
    [_tableView reloadData];
    NSLog(@"_historyData = %@",_historyData);
}
#pragma Mark --- 基础处理功能
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self readNSUserDefaults];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self creatSearch];
    [self creatView];
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
