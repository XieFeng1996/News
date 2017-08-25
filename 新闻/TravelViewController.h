//
//  TravelViewController.h
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface TravelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_TraveView;
    NSMutableArray *_TraveTime;
    NSMutableArray *_TraveTitle;
    NSMutableArray *_TravepicUrl;
    NSMutableArray *_TraveURL;
    NSMutableArray *_Travedescription;
    
    UIActivityIndicatorView *_Traveindicator;
    UIActivityIndicatorView *_Traveindicator2;
    AFHTTPSessionManager *_Travesession;
}
-(void)TravelstartContent;
@end
