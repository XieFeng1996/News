//
//  SearchManger.m
//  新闻
//
//  Created by 谢风 on 2017/8/23.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "SearchManger.h"

@implementation SearchManger
#pragma Mark ---- 缓存数组
+(void)SearchText:(NSString *)search{
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //读取数组NSArray类型的数据
    NSArray *historyArray = [userDefaultes arrayForKey:@"history"];
    if (historyArray.count>0) {
        //先取出数组，判断是否有值，有值继续添加，无值创建数组
    }else{
        historyArray = [NSArray array];
    }
    NSMutableArray *searchArray = [historyArray mutableCopy];
    [searchArray addObject:search];
    if (searchArray.count>5) {
        [searchArray removeObjectAtIndex:0];
    }
    //存储到NSUserDefaults中
    [userDefaultes setObject:searchArray forKey:@"history"];
    [userDefaultes synchronize];
}
#pragma Mark ---- 移除数组
+(void)removeAllArray{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"history"];
    [userDefaults synchronize];
}
@end
