//
//  LoginViewController.h
//  不正经新闻
//
//  Created by 谢风 on 2017/8/29.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginSuccess.h"  //用于实现代理对象
@interface LoginViewController : UIViewController<UIActionSheetDelegate,LoginSuccessDelegate,UITextFieldDelegate>

//代理实现
-(void)showAvatar:(NSString *)LoginAvatar;

@property(nonatomic,readwrite,copy)NSString *dbPath; //存储文件路径
@property(nonatomic,readwrite,copy)NSString *Avatar; //当前登陆的账号图片，用于在当前界面显示小头像
@property(nonatomic,readwrite,assign)NSInteger LoginID; //当前登陆者的ID

@property (weak, nonatomic) IBOutlet UIImageView *allBackgroundImage; //背景图片
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;    //使用者头像
@property (weak, nonatomic) IBOutlet UITextField *UserAcount;   //账号
@property (weak, nonatomic) IBOutlet UITextField *UserPassword; //密码

- (IBAction)NewsDelegate:(id)sender;//新闻协议按钮
@property (weak, nonatomic) IBOutlet UIButton *dele;//用于按钮上的修改文字

- (IBAction)Login:(id)sender;//账号登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *login;
- (IBAction)Regiest:(id)sender;//账号注册按钮
@property (weak, nonatomic) IBOutlet UIButton *regiest;
- (IBAction)closs:(id)sender;//关闭登陆按钮
@property (weak, nonatomic) IBOutlet UIButton *closs;
@end
