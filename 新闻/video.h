//
//  video.h
//  新闻
//
//  Created by 谢风 on 2017/8/19.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface video : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    //每次下拉更新就是重新链接一次
    UITableView *_videoTableView;
    
    NSMutableArray *_videoData;
    
    UIImage *_VideoImage;
    UIImageView *_imageFrame;
}
-(void)videoStart;
@property(nonatomic,strong)MPMoviePlayerController *moviePlay;
@end
