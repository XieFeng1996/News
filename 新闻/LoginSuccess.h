//
//  LoginSuccess.h
//  不正经新闻
//
//  Created by 谢风 on 2017/8/30.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
  委托回调
 */
@protocol LoginSuccessDelegate

-(void)showAvatar:(NSString *)LoginAvatar;//改变头像
-(void)LoginOut:(BOOL)Out;                //注销登录信息
@end

@interface LoginSuccess : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_textLabelArray; //存储的是显示内容
    NSMutableArray *_LoginData;      //存储登陆者的信息内容
    NSMutableArray *_AvatarData;     //储存头像
    
}


//展示整个大的头像图片
@property (weak, nonatomic) IBOutlet UIImageView *showAllAvatar;
@property(nonatomic,readwrite,assign)NSInteger WhoID;    //登陆者的ID
@property(nonatomic,readwrite,copy)NSString *dbPath; //存储文件路径 --->用于FMDB


@property (weak, nonatomic) IBOutlet UILabel *loginSex; //登陆者的性别
@property (weak, nonatomic) IBOutlet UILabel *loginAge; //登陆者的年龄

//委托
@property(nonatomic,weak)id<LoginSuccessDelegate> delegate;

//PickView加载数据
@property(nonatomic,strong)NSArray *number; //保存展示的数字

@end
