//
//  HotView.h
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowHot.h"

@interface HotView : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UITableView *_table;
    UIAlertView *_alertView;
    NSMutableArray *_mutableArray;  //用于显示的数据源,只有10个
    NSMutableArray *_ArrayData;     //用于储存当天的所有资讯热点
    UIBarButtonItem *_btnLoadData;
    ShowHot *_showHot;
    
    UIScrollView *_scroll;
}
-(void)ConnectToTheServer;
-(void)ParseData:(NSDictionary *)dicData;
-(void)creatUITableView;
-(void)LoadTheSearchData:(NSString *)Data;//检索数据获得
@property(nonatomic,strong)UIView *rightView;
@property(nonatomic,strong)UIView *leftView;
@end
