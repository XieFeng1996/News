//
//  AppDelegate.m
//  新闻
//
//  Created by 谢风 on 2017/8/10.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "AppDelegate.h"
#import "FindView.h"
#import "HotView.h"
#import "MYView.h"
#import "AdvertiseView.h"
#import "CollectionView.h"
/*
  以热点资讯为主视图
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    FindView *find = [[FindView alloc]init];
    HotView *hot = [[HotView alloc]init];
    MYView *my = [[MYView alloc]init];
    CollectionView *coll = [[CollectionView alloc]init];
    
    //导航控制器
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:hot];
    
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:my];
    
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:coll];
    
    find.view.backgroundColor = [UIColor whiteColor];
    hot.view.backgroundColor =[UIColor whiteColor];
    my.view.backgroundColor = [UIColor whiteColor];
    coll.view.backgroundColor = [UIColor whiteColor];
    
    UITabBarController *tbc = [[UITabBarController alloc]init];
    
    NSArray *arrayVC = [NSArray arrayWithObjects:find,nav,nav3,nav2,nil];
    
    tbc.viewControllers = arrayVC;
    tbc.selectedIndex = 1;
    
    self.window.rootViewController = tbc;
    
    tbc.tabBar.translucent =NO;
    tbc.tabBar.backgroundColor = [UIColor blackColor];
    
    //判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
        
    }
    //无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
    
    [self setNotificationCategorys];
    //设置代理
    [UNUserNotificationCenter currentNotificationCenter].delegate =self;
    
    return YES;
}
-(void)setNotificationCategorys{
    //申请通知权限
    [[UNUserNotificationCenter currentNotificationCenter]requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            NSLog(@"注册成功");
            //创建通知内容
            UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
            //标题
            content.title = @"新一年的世萌开赛了";
            //次标题
            content.subtitle = @"骚年，二次元的世界在等着你.";
            //内容
            content.body = @"2017年新一届世萌开选了，你心目中的萌王是谁？赶紧来参加投票吧，为你心目中的萌王投上宝贵的一票。";
            //通知提示声音,默认
            content.sound = [UNNotificationSound defaultSound];
            
//            NSURL *imageURl = [[NSBundle mainBundle]URLForResource:@"P4" withExtension:@".jpg"];
//            UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"image" URL:imageURl options:nil error:nil];
//            
//            //附件，可以是音频、图片、视频
//            content.attachments = @[attachment];
            
            //标识符
            content.categoryIdentifier = @"shimeng";
            
            //触发通知
            UNTimeIntervalNotificationTrigger *trigger =[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
            
            //创建通知请求
            UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"KFGroupNotification" content:content trigger:trigger];
            
            //将请求加入通知中心
            [[UNUserNotificationCenter currentNotificationCenter]addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"已成功加推送%@",notificationRequest.identifier);
                }
            }];
        }
    }];
}
#pragma Mark --- 广告相关
/**
 *  判断文件是否存在
 */
-(BOOL)isFileExistWithFilePath:(NSString *)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}
/**
 *  初始化广告页面
 */
-(void)getAdvertisingImage{
    NSArray *imageArray = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503638685343&di=041bdc8e5c006360f4f29d6129deafe5&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201604%2F30%2F20160430203535_2XiUf.thumb.700_0.png", @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1503638927161&di=3d2431429e3b7910cb73f0099b082ee3&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201509%2F30%2F20150930183149_42sCQ.jpeg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
        
    }

}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}
/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName{
    if (imageName) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//应用内展示通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //执行此方法
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}
@end
