//
//  AdvertiseView.h
//  新闻
//
//  Created by 谢风 on 2017/8/25.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kscreenWidth [UIScreen mainScreen].bounds.size.width
#define kscreenHeight [UIScreen mainScreen].bounds.size.height
#define kUserDefaults [NSUserDefaults standardUserDefaults]

static NSString *const adImageName = @"adImageName";
static NSString *const adURL = @"adURL";
@interface AdvertiseView : UIView

/* 显示广告方法*/
-(void)show;

/* 图片路径*/
@property(nonatomic,copy)NSString *filePath;
@end
