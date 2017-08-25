//
//  SearchView.h
//  新闻
//
//  Created by 谢风 on 2017/8/22.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SearchView : UIViewController<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UISearchBar *_searchBar;
    UIActivityIndicatorView *_indicatorView;
    UIActivityIndicatorView *_indicatorView2;
    UIView *_view;
    UITableView *_tableView;
    UITableView *_downView;
    
    NSMutableArray *_ResultData;
}
@property(nonatomic,retain)NSArray *historyData;//数组数据,记录搜索历史数据
@end
