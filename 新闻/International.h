//
//  International.h
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface International : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrayTime;
    NSMutableArray *_arrayTitle;
    NSMutableArray *_picUrl;
    NSMutableArray *_arrayURL;
    NSMutableArray *_description;
    
    UIActivityIndicatorView *_indicator;
    UIActivityIndicatorView *_indicator2;
    AFHTTPSessionManager *_session;
}
-(void)InterStartContent;
@end
