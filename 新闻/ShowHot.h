//
//  ShowHot.h
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowHot : UIViewController{
    UIImageView *_NewsImage;            //新闻图片显示
    UILabel *_NewsText;              //新闻内容
    UILabel *_NewsTitle;                //新闻标题
    UILabel *_NewsFull_Title;           //新闻副标题
    UILabel *_NewsSrc;                  //新闻来源
    UILabel *_NewsReadTime;             //新闻阅读时间（当前日期和时间）
    UILabel *_NewsURL;                  //网址原链接
    UIScrollView *_News;                //滚动视图，新闻中的所有都会放到滚动视图中
    UIActivityIndicatorView *_activityIndicator; //提示
    UIAlertView *_alertView;
    
    UIBarButtonItem *_Jump;             //跳转WebView视图

}
@property(nonatomic,retain)NSString *HttpHard;
@property(nonatomic,retain)NSString *SrcUrl;
-(void)RetrieveData:(NSString *)data;         //检索数据
-(void)Analytical:(NSDictionary *)dicData;    //解析数据
-(void)crateDisplayDataImageView;             //显示数据视图
@end
