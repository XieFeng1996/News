//
//  FindView.h
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildViewControl.h"
@interface FindView : UIViewController<UIScrollViewDelegate>
{
    float lastContentOffset;
    Domestic *_dome;
    International *_inter;
    TravelViewController *_trave;
    SocietyViewController *_society;
    JokeViewController *_joke;
    video *_video;
}
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIScrollView *titleScrollview;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;


@end
