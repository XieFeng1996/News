//
//  JokeViewController.h
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JokeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_arrayContent;
    NSMutableArray *_arrayTime;
    NSMutableArray *_arrayImageUrl;
    
    UIRefreshControl *_freshControl;
    UIActivityIndicatorView *_indicator;

}
-(void)startConentNetWork:(NSInteger )page;
@end
