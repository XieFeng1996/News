//
//  LoginViewController.m
//  不正经新闻
//
//  Created by 谢风 on 2017/8/29.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "LoginViewController.h"
#import "FMDatabase.h"
#import "LoginSuccess.h"
@interface LoginViewController ()
{
    FMDatabase *_FMDB;
}
@end

@implementation LoginViewController
#pragma Mark --- 代理实现方法
-(void)showAvatar:(NSString *)LoginAvatar{
    //更改头像
    NSString *Avatar = [NSString stringWithFormat:@"%@.png",LoginAvatar];
    UIImage *AvatarImage = [UIImage imageNamed:Avatar];
    self.UserImage.image =AvatarImage;
}
-(void)LoginOut:(BOOL)Out{
    if (Out) {
        //注销登陆操作
        UIButton *btn = (UIButton *)[self.view viewWithTag:111];
        UIButton *btn2 = (UIButton *)[self.view viewWithTag:112];
        //移除自定义按钮
        [btn removeFromSuperview];
        [btn2 removeFromSuperview];
        //重新显示登陆、注册按钮、关闭按钮
        [self.login setHidden:NO];
        [self.regiest setHidden:NO];
        [self.closs setHidden:NO];
        //清空账号密码
        _UserAcount.text = nil;
        _UserPassword.text = nil;
        //原图片重置为未登陆状态
        self.UserImage.image = [UIImage imageNamed:@"login_phonenum_headimg"];
    }else{
        return;
    }
}
#pragma Mark ---数据库操作
-(void)creatSQlist{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *path =[doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    
    NSFileManager *fileManger = [NSFileManager defaultManager]; //文件路径
    
    if ([fileManger fileExistsAtPath:self.dbPath]==NO) {
        //创建和打开表
        FMDatabase *db = [FMDatabase databaseWithPath:path];
        if (db !=nil) {
            NSLog(@"表创建成功");
        }
        BOOL isopen = [db open];
        if (isopen) {
            NSLog(@"数据库打开成功");
            /*
              数据表内容
            1.ID
            2.密码
            3.账号
            4.性别 (0:女 1：男 2：保密)
            5.头像 blob
            6.年龄
            7.昵称
             */
            NSString *sql = @"create table if not exists userdata(id interger,password varchar(20),Account varchar(20),Sex integer,Avatar varchar(20),Age integer,Nickname varchar(20))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"数据表创建失败");
            }else{
                NSLog(@"数据表创建成功");
                //插入初始化数据
                NSString *strInsert = @"insert into userdata values(1,1234,'Pyrrha',0,'A1',17,'PyrrhaNikos');";
                BOOL isInsert = [db executeUpdate:strInsert];
                if (isInsert) {
                    NSLog(@"初始化数据成功");
                }else{
                    NSLog(@"初始化数据失败");
                }
            }
        }else{
            NSLog(@"数据库打开失败");
        }
        [db close];
    }else{
        NSLog(@"数据库已存在");
    }
}
#pragma Mark ---查询是否可以往数据库中添加数据
-(BOOL)QueryOperation:(NSString *)QuaeryName{
    //是否注册成功，默认不成功
    BOOL isExist = false;
    _FMDB = [FMDatabase databaseWithPath:self.dbPath];
    if ([_FMDB open]) {
        NSString *strQuery = @"select *from userdata";
        FMResultSet *rs = [_FMDB executeQuery:strQuery];
        //创建空的账号数组
        NSMutableArray *accountArray = [NSMutableArray array];
        while ([rs next]) {
            NSString *account = [rs stringForColumn:@"Account"];
            [accountArray addObject:account];
        }
        BOOL isbool = [accountArray containsObject:QuaeryName];
        if (!isbool) {
            isExist = true;
        }
    }
    return isExist;
}
#pragma Mark --- textField代理实现
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //创建数据表
    [self creatSQlist];
    //设置输入框的代理
    _UserAcount.delegate =self;
    _UserPassword.delegate = self;
    
    //设置按钮文字带下划线
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"不正经协议"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [_dele setAttributedTitle:str forState:UIControlStateNormal];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
#pragma Mark --- 弹出提示
-(void)pushAlertController:(NSString *)title andMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma Mark --- 注销登陆
-(void)writeOff{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"注销登陆" delegate:self cancelButtonTitle:@"退出" destructiveButtonTitle:@"注销" otherButtonTitles:nil];
    
    [sheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
       //注销登陆
        [self LoginOut:true];
    }
}
#pragma Mark --- 切换到登陆成功界面
-(void)gotoLoginSuccess{
    
    /*发送一个头像消息给登陆成功界面*/
    LoginSuccess *su = [LoginSuccess new];
    //将登陆者名字正向传值给下一个界面
    su.WhoID = self.LoginID;
    //调用委托回调
    su.delegate = self;
    [self.navigationController pushViewController:su animated:YES];
}
#pragma Mark --- 按钮处理
- (IBAction)NewsDelegate:(id)sender { //不正经协议
    [self pushAlertController:@"协议" andMessage:@"协议1:略\n协议2:略\n协议3:略\n俗称：略法三章"];
}
- (IBAction)Login:(id)sender { //登陆
    //查询数据库
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    
    //回收键盘
    [_UserAcount resignFirstResponder];
    [_UserPassword resignFirstResponder];
    
    if ([db open]) {
        NSString *sql = @"select *from userdata";
        NSMutableDictionary *dictonary = [NSMutableDictionary dictionary]; //空字典
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
          
            /*
              需要的其实只有账号和密码，用于全部存储到字典中
             这里开着是为了给我看所有的账号信息
             */
           NSInteger ids = [rs intForColumn:@"id"];
           NSString *account = [rs stringForColumn:@"Account"];
           NSString *password = [rs stringForColumn:@"password"];
           NSInteger sex = [rs intForColumn:@"Sex"];
           NSString *avater = [rs stringForColumn:@"Avatar"];
           NSInteger age = [rs intForColumn:@"Age"];
           NSString *nickname = [rs stringForColumn:@"Nickname"];
            
           NSLog(@"(%ld,%@,%@,%ld,%@,%ld,%@)",ids,account,password,sex,avater,age,nickname);
            
            //账号对应密码的存储方式
            [dictonary setValue:password forKey:account];
        }
        //输出全部的账号密码--->打开即可查看
        //NSLog(@"alldata = %@",dictonary);
        //通过KEY来找到Value
        NSObject *object = [dictonary objectForKey:_UserAcount.text];
        if (object!=nil) {
            if ([object isEqual:_UserPassword.text]) {
                UIActivityIndicatorView *indica = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                indica.center = self.view.center;
                [indica startAnimating];
                [self.view addSubview:indica];
                
                //查找当前账号名对应的数据
                rs = [db executeQueryWithFormat:@"select *from userdata where Account = %@",_UserAcount.text];
                while ([rs next]) {
                    //获得对应账号的ID
                    NSInteger IDS = [rs intForColumn:@"id"];
                    
                    //获得对应账号的图片
                    NSString *strAvatar = [rs stringForColumn:@"Avatar"];
     
                    //赋值操作
                    self.Avatar = strAvatar;
                    self.LoginID = IDS;
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [indica stopAnimating];
                    [indica removeFromSuperview];
                    
                    //本地界面 --->原登陆/注册/关闭按钮隐藏，同样的位置出一个注销
                    [self.login setHidden:YES];
                    [self.regiest setHidden:YES];
                    [self.closs setHidden:YES];
                    
                    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    btn.frame = CGRectMake(30, 241, 278, 48);
                    [btn setBackgroundImage:[UIImage imageNamed:@"off_btn"] forState:UIControlStateNormal];
                    btn.tag = 111;
                    [btn addTarget:self action:@selector(writeOff) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:btn];
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    button.layer.cornerRadius = 15.0f; //圆角
                    button.frame = CGRectMake(220,20,80, 40);
                    button.backgroundColor = [UIColor grayColor];
                    [button setTitle:@"详细设置" forState:UIControlStateNormal];
                    button.tag = 112;
                    [button addTarget:self action:@selector(gotoLoginSuccess) forControlEvents:UIControlEventTouchUpInside];
                    
                    [self.view addSubview:button];
                    
                    /*改变登陆后的头像*/
                    [UIView animateWithDuration:1 animations:^{
                        //圆形头像
                        self.UserImage.layer.cornerRadius = 42;
                        self.UserImage.layer.masksToBounds =YES;
                        NSString *userImagePath = [NSString stringWithFormat:@"%@.png",self.Avatar];
                        self.UserImage.image = [UIImage imageNamed:userImagePath];
                    }];
                });
            }else{
                [self pushAlertController:@"登陆失败" andMessage:@"请输入正确的账号密码（密码错误）"];
                _UserAcount.text = nil;
                _UserPassword.text = nil;
            }
        }else{
            [self pushAlertController:@"登陆失败" andMessage:@"请输入正确的账号密码"];
            _UserAcount.text = nil;
            _UserPassword.text = nil;
        }
    }else{
        NSLog(@"数据库不存在");
    }
    [db close];
}
- (IBAction)Regiest:(id)sender { //注册
    
    if (_UserAcount.text.length !=0&&_UserPassword.text.length!=0) {
        //当前账号名判断是否已经存在
        BOOL canRegiest = [self QueryOperation:_UserAcount.text];
        if (canRegiest) {
            //获得数据库最后一个ID
            NSString *query = @"select *from userdata";
            FMResultSet *rs = [_FMDB executeQuery:query];
            NSInteger lastID = 1;
            while ([rs next]) {
                lastID = [rs intForColumn:@"id"];
            }
            //除账号密码和ID外全部用默认值代替
            BOOL us = [_FMDB executeUpdateWithFormat:@"insert into userdata values(%ld,%@,%@,0,'A1',0,'无名氏');",lastID+1,_UserPassword.text,_UserAcount.text];
            if (us) {
                [self pushAlertController:@"本地化注册" andMessage:@"模拟注册成功"];
            }else{
                [self pushAlertController:@"本地化注册" andMessage:@"模拟注册失败"];
            }
        }else{
            [self pushAlertController:@"本地注册失败" andMessage:@"当前账号已被注册"];
            _UserAcount.text = nil;
            _UserPassword.text = nil;
        }
    }else{
        [self pushAlertController:@"注册失败" andMessage:@"请输入你的账号密码"];
        _UserAcount.text = nil;
        _UserPassword.text = nil;
    }
    
}
- (IBAction)closs:(id)sender { //关闭
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
