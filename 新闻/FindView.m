//
//  FindView.m
//  新闻
//
//  Created by 谢风 on 2017/8/15.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "FindView.h"
#import "ChildViewControl.h"
#import "SearchView.h"
#define KScreenWidth   375
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

#define TitleColor(a,b,c) [UIColor colorWithRed:a green:b blue:c alpha:1]
@interface FindView ()
@property(nonatomic,strong)NSMutableArray *allButtons;
@end

@implementation FindView
NSInteger JokePage = 1;
NSInteger DomePage = 1;
NSInteger InterPage =1;
NSInteger SportPage =1;
NSInteger TravePage =1;
NSInteger SocietPage =1;
NSInteger VideoPage =1;
#pragma Mark  -------Title标题,也是内容滚动视图的子控制器
-(void)setTitleScrollView{
    
    _dome = [[Domestic alloc]init];
    _dome.title =@"国内";
    [self addChildViewController:_dome];
    
    _inter = [[International alloc]init];
    _inter.title = @"国际";
    [self addChildViewController:_inter];
    
    _society = [[SocietyViewController alloc]init];
    _society.title = @"社会";
    [self addChildViewController:_society];
    
    _trave= [[TravelViewController alloc]init];
    _trave.title = @"旅游";
    [self addChildViewController:_trave];
    
    _video = [[video alloc]init];
    _video.title = @"视频";
    
    [self addChildViewController:_video];
    
    _joke = [[JokeViewController alloc]init];
    _joke.title = @"笑话";
    [self addChildViewController:_joke];
}
#pragma Mark  -------设置标题和内容
-(void)setContentScrollView{
    NSInteger count = self.childViewControllers.count;
    
    //标题宽度
    CGFloat titleWidth = 60;
    //内容页面占据的高度
    CGFloat contentHeight =_contentScrollView.bounds.size.height;
    
    
    for (NSInteger i=0; i<count; i++) {
        //先拿到对应的子控制器
        UIViewController *VC = self.childViewControllers[i];
        VC.view.frame = CGRectMake(i*KScreenWidth, 0, KScreenWidth,contentHeight);
        [_contentScrollView addSubview:VC.view];
        
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag =i;
        
        [btn setTitle:VC.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置按钮位置
        CGFloat btnX =i*titleWidth;
        btn.frame = CGRectMake(btnX, 0, titleWidth, 50);
        
        [_titleScrollview addSubview:btn];
        [self.allButtons addObject:btn]; //注意不能使用_allButtons，这里是调用懒加载
        
        //监听事件
        [btn addTarget:self action:@selector(ClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //设置标题滚动区的范围
    _titleScrollview.contentSize = CGSizeMake((count*titleWidth)+50, 0);
    _titleScrollview.showsHorizontalScrollIndicator = NO;
    
    //设置内容滚动区的范围(现在只能左右移动)
    _contentScrollView.contentSize = CGSizeMake(count*KScreenWidth, 0);
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate = self;
    
    
    //设置标题初始状态
    UIButton *firstBtn = self.allButtons[0];
    [self ClickBtn:firstBtn];
    [firstBtn setTitleColor:TitleColor(1, 0, 0) forState:UIControlStateNormal];
    firstBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    [_dome startConnect];
}
-(void)ClickBtn:(UIButton *)titleButton{
    //title滚动区，选中的标题自动会根据情况移动居中
    [self titleScrollViewChangeWithBtnTag:titleButton.tag];
    //content滚动区，根据选中的标题切换到对应的页面内容
    [self contentScrollViewChangWithBtnTag:titleButton.tag];
    //点击
    [self clickOrSlideEvents:titleButton.tag];
}
#pragma Mark  ---- 按钮监听事件
-(void)titleScrollViewChangeWithBtnTag:(NSInteger )tag{
    UIButton *btn = _allButtons[tag];
    //计算得出当前应该设置的偏移量
    CGFloat offset = btn.center.x - KScreenWidth*0.5;
    if (offset<0) {
        offset =0;
    }
    CGFloat maxOffset = _titleScrollview.contentSize.width - KScreenWidth;
    if (offset>maxOffset) {
        offset = maxOffset;
    }
    
    //动态设置标题滚动区的偏移量
    [_titleScrollview setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}
-(void)contentScrollViewChangWithBtnTag:(NSInteger )tag{
    //计算当前内容区域的偏移量
    CGFloat offset = KScreenWidth *tag;
    [_contentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
#pragma Mark  ---- UIScrollView协议
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //通过偏移量计算 获取当前页面的角标
    NSInteger index = scrollView.contentOffset.x/KScreenWidth;
    //结束滚动，重置title滚动区域的按钮位置
    [self titleScrollViewChangeWithBtnTag:index];
    //滚动调用
    [self clickOrSlideEvents:index];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //先拿到相邻的角标
    NSInteger leftIndex = scrollView.contentOffset.x /KScreenWidth;
    leftIndex = (leftIndex >=_allButtons.count -2)?(self.allButtons.count -2):leftIndex;
    NSInteger rightIndex = leftIndex+1;
    
    //根据角标拿到对应的title
    UIButton *leftButton = _allButtons[leftIndex];
    UIButton *rightButton = _allButtons[rightIndex];
    
    //然后拿到相邻区域的leftwidth和rightwidth
    CGFloat leftWidth = rightIndex*KScreenWidth - scrollView.contentOffset.x;
    CGFloat rightWidth = KScreenWidth - leftWidth;
    
    //获取leftScale和rightScale
    CGFloat leftScale = leftWidth/KScreenWidth;
    CGFloat rightScale = rightWidth/KScreenWidth;
    
    //先处理title字体随滚动内容区域的形变
    leftButton.transform = CGAffineTransformMakeScale(leftScale*0.3+1, leftScale*0.3+1);
    rightButton.transform = CGAffineTransformMakeScale(rightScale*0.3+1, rightScale*0.3+1);
    
    //处理title字体的颜色值
    [leftButton setTitleColor:TitleColor(leftScale, 0, 0) forState:UIControlStateNormal];
    [rightButton setTitleColor:TitleColor(rightScale, 0, 0) forState:UIControlStateNormal];
    
}
#pragma Mark  ---- 对应点击事件或者滑动事件
-(void)clickOrSlideEvents:(NSInteger)TAG{
    NSInteger Index = TAG;
    switch (Index) {
        case 0:
            //国内，不做处理
            break;
        case 1:
            //调用国际新闻
            InterPage++;
            if (InterPage<=2) {
                [_inter InterStartContent];
            }
            break;
        case 2:
            //社会
            SocietPage++;
            if (SocietPage<=2) {
                [_society societyStartContent];
            }
            break;
        case 3:
            //旅游新闻
            TravePage++;
            if (TravePage<=2) {
                [_trave TravelstartContent];
            }
            break;
        case 4:
            //视频
            VideoPage++;
            if (VideoPage<=2) {
                [_video videoStart];
            }
            break;
        case 5:
            //笑话
            JokePage++;
            if (JokePage<=2) {
                [_joke startConentNetWork:JokePage];//防止继续左划更新
            }
            break;
        default:
            break;
    }
}
#pragma Mark  ---- 懒加载可变数组
-(NSMutableArray *)allButtons{
    if (_allButtons == nil) {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}
#pragma Mark  ----transitionFromViewController移动视图
/**********************--------------------**********************
 
 transitionFromViewController--->子view未显示时，不会load，内存紧张时没load的view将被首先释放
 
 -(void)transitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL))completion{
 }
 
  参数
 fromViewController:当前显示在父视图控制器中的子视图控制器
 toViewController:将要显示的子视图控制器
 duration：完成过渡的时间，单位秒
 options:指定的过渡效果
 animations:转换过程中的动画，block块操作
 completion:过渡完成执行block块操作
 
  该方法执行完以后，fromViewController指代的视图控制器的view将从界面消失，toViewController所指代的视图控制器的view将被载入到页面中
 **********************--------------------**********************/
#pragma Mark  ---- view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *img = [[UIImage imageNamed:@"find"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tab = [[UITabBarItem alloc]initWithTitle:@"发现" image:img tag:1];
    UIBarButtonItem *Search = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(SearchNews)];
    self.tabBarItem =tab;
    _navigationBar.topItem.leftBarButtonItem = Search;
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self setTitleScrollView];
    [self setContentScrollView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Mark  ------- 搜索
-(void)SearchNews{
    SearchView *search = [[SearchView alloc]init];
    //[self.navigationController pushViewController:search animated:YES];
    [self presentViewController:search animated:YES completion:nil];
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
