//
//  MYView.h
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
/**
  图片轮播
 */
@interface MYView : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    UIScrollView *_scroll;
    UIPageControl *_page;
    UITableView *_tableView;
    NSTimer *_timer;
    NSMutableArray *_arrayData;
    UIAlertView *_alert;
    FMDatabase *_FMDB;
}
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *leftView;
@end
