//
//  SearchManger.h
//  新闻
//
//  Created by 谢风 on 2017/8/23.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchManger : NSObject
//缓存搜索的数组
+(void)SearchText:(NSString *)search;
//清除缓存数组
+(void)removeAllArray;
@end
