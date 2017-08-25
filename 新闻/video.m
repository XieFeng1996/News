//
//  video.m
//  新闻
//
//  Created by 谢风 on 2017/8/19.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "video.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "VideoModel.h"
#define video_Uploader  1
#define video_Uploader_Icon 2
#define video_Image 3
#define video_View 4
#define video_Title 5
#define video_Tag 6
@interface video ()

@end

@implementation video
#pragma Mark --- 开始函数
-(void)videoStart{
    [self Initialization];
    NSString *http = @"https://sv.baidu.com/platapi/v2/video_list?from=rec&rn=99&lid=947a4711ba3aaeb66dd552a2486fb543&cuid=&tag=doubiju&bid=E04B53E1804263C5153C99A4C9CD374A:FG=1&cb_cursor=undefined&hot_cursor=undefined&offline_cursor=undefined&cursor_time=undefined&sessionid=E04B53E1804263C5153C99A4C9CD374A:FG=1&vsid=80000002&swd=414&sht=736";
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:http parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self dataAnalysis:responseObject];
        }else{
            NSLog(@"非字典结构");
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
#pragma Mark --- 数据解析函数
-(void)dataAnalysis:(NSDictionary *)responseObject{
    NSDictionary *data = [responseObject objectForKey:@"data"];

    NSArray *list = [data objectForKey:@"list"];
    
    for (NSInteger i=0; i<list.count; i++) {
        VideoModel *model = [[VideoModel alloc]init];
        NSDictionary *baseData = [list objectAtIndex:i];
        
        NSString *author = [baseData objectForKey:@"author"];
        model.Author = author;
        
        NSString *author_icon = [baseData objectForKey:@"author_icon"];
        model.Author_iron = author_icon;
        
        NSString *cover_src = [baseData objectForKey:@"cover_src"];
        model.Cover_src = cover_src;
        
        NSString *title = [baseData objectForKey:@"title"];
        model.Title = title;
        
        NSString *mp4= [baseData objectForKey:@"video_src"];
        model.MP4URL = mp4;
        
        NSString *pageUrl = [baseData objectForKey:@"pageUrl"];
        model.PageUrl = pageUrl;
        [_videoData insertObject:model atIndex:0];
        
    }
    [_videoTableView reloadData];
}
#pragma Mark --- UITableView极其协议
-(void)creatVideoTableView{
    _videoTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _videoTableView.backgroundColor = [UIColor clearColor];
    _videoTableView.delegate = self;
    _videoTableView.dataSource = self;
    [self.view addSubview:_videoTableView];
}
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"video";
    UILabel *videoUploader; //视频上传人 ---->对应tname
    UIImageView *videoUploader_Icons;//视频上传人头像 --->对应topic_icons
    UIImageView *videoImage;   //视频图片，点击播放视频
    UIView *grayView;          //假装是个点击按钮
    UILabel *videoTitle;       //视频标题
    
    UITableViewCell *cell = [_videoTableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        videoUploader = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, 100, 20)];
        videoUploader.tag = video_Uploader;
        videoUploader.font = [UIFont systemFontOfSize:12];
        videoUploader.textColor = [UIColor grayColor];
        videoUploader.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:videoUploader];
        
        videoTitle = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, cell.frame.size.width-120, 40)];
        videoTitle.tag =video_Title;
        videoTitle.font = [UIFont systemFontOfSize:12];
        videoTitle.textColor = [UIColor blackColor];
        videoTitle.textAlignment = NSTextAlignmentLeft;
        videoTitle.numberOfLines =0;
        [cell.contentView addSubview:videoTitle];
        
        videoUploader_Icons =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        videoUploader_Icons.tag = video_Uploader_Icon;
        [cell.contentView addSubview:videoUploader_Icons];
        
        videoImage  = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, cell.frame.size.width, 255)];
        videoImage.tag = video_Image;
        [cell.contentView addSubview:videoImage];
        
        grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, cell.frame.size.width, 255)];
        grayView.backgroundColor = [UIColor grayColor];
        grayView.alpha =0.6;
        [cell.contentView addSubview:grayView];

    }else{
        videoUploader = (UILabel *)[cell.contentView viewWithTag:video_Uploader];
        videoUploader_Icons = (UIImageView *)[cell.contentView viewWithTag:video_Uploader_Icon];
        videoImage = (UIImageView *)[cell.contentView viewWithTag:video_Image];
        grayView = (UIView *)[cell.contentView viewWithTag:video_View];
        videoTitle = (UILabel *)[cell.contentView viewWithTag:video_Title];
    }
    
    VideoModel *model = _videoData[indexPath.row];
    
    videoUploader.text = model.Author;
    videoTitle.text = model.Title;
    
    UIImage *image =[UIImage imageNamed:@"load.jpg"];
    _VideoImage = [UIImage imageNamed:@"Video.png"];
    _imageFrame = [[UIImageView alloc]initWithImage:_VideoImage];
    _imageFrame.frame = CGRectMake(grayView.center.x-60, grayView.center.y-60, 100, 80);
    [grayView addSubview:_imageFrame];
    
    NSString *Author_URL = model.Author_iron;
    NSURL *URl = [NSURL URLWithString:Author_URL];
    
    NSString *Image_Str = model.Cover_src;
    NSURL *Image_URL = [NSURL URLWithString:Image_Str];
    
    [videoUploader_Icons sd_setImageWithURL:URl placeholderImage:image];
    
    [videoImage sd_setImageWithURL:Image_URL placeholderImage:image];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor grayColor];
    view.tag = video_Tag;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backVideo) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    VideoModel *model = _videoData[indexPath.row];
    
    //使用MPMoviePlayerController进行视频播放
    NSString *MP4URL = model.MP4URL;
    NSURL *URL = [NSURL URLWithString:MP4URL];
    _moviePlay = [[MPMoviePlayerController alloc]initWithContentURL:URL];
    _moviePlay.view.frame = CGRectMake(0, 40, self.view.frame.size.width-40, 290);
    _moviePlay.scalingMode = MPMovieScalingModeAspectFill;//固定缩放比例
    [view addSubview:_moviePlay.view];
    [_moviePlay prepareToPlay];
    //添加视频播放通知
    [self addNofi];
    [self.view addSubview:view];

}
#pragma Mark ---- 视频播放处理工作
-(void)backVideo{
    UIView *view = (UIView *)[self.view viewWithTag:video_Tag];
    [_moviePlay stop];
    [view removeFromSuperview];
}
-(void)addNofi{
    //媒体播放完成或用户手动退出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playDidFinish:) name:MPMoviePlayerDidExitFullscreenNotification object:nil];
}
-(void)playDidFinish:(NSNotification *)noti{
    //播放结束
    UIView *view = (UIView *)[self.view viewWithTag:video_Tag];
    [view removeFromSuperview];
}
#pragma Mark ---- 初始化函数
-(void)Initialization{
    //处理初始化事件
    _videoData = [[NSMutableArray alloc]init];
}
#pragma Mark ---- 处理函数
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self creatVideoTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
