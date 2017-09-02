//
//  CollectionView.m
//  不正经新闻
//
//  Created by 谢风 on 2017/8/27.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "CollectionView.h"
#import "MYCollectionViewCell.h"
@interface CollectionView ()

@end

@implementation CollectionView

#pragma Mark --- 设置瀑布流
-(void)setCollectionView{
    //创建布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //最小列间距
    layout.minimumInteritemSpacing =0;
    //最小行间距
    layout.minimumLineSpacing =0;
    //使用默认四边距
    //layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //使用默认竖直滑动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collection];
    collection.delegate = self;
    collection.dataSource = self;
    
    //注册cell
    [collection registerClass:[MYCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    //注册分区头
    //[collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"healer"];
    collection.backgroundColor = [UIColor grayColor];
}
//代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    MYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.bgImageView.image = [UIImage imageNamed:@"P1.jpg"];
    cell.titleLabel.text = @"P姐";
    
    return cell;
}
//控制每一个方块的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.view.frame.size.width
                      /2, 200);
}
/*
//控制分区的代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(375, 40);
}

//自定义分区
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) { //判断分区头
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"healer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor yellowColor];
        view.alpha = 0.6;
        return view;
    }
    return nil;
}
*/
//点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"你点了第%ld分区的第%ld个美女",indexPath.section,indexPath.row);
}
#pragma Mark --- 基础处理
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *img = [[UIImage imageNamed:@"图片.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tab = [[UITabBarItem alloc]initWithTitle:@"图片" image:img tag:3];
    self.tabBarItem = tab;
    self.navigationItem.title = @"美图";
    
    [self setCollectionView];
    
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
