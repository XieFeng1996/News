//
//  LoginSuccess.m
//  不正经新闻
//
//  Created by 谢风 on 2017/8/30.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "LoginSuccess.h"
#import "FMDatabase.h"
#import "ViewInViewCell.h"
@interface LoginSuccess ()
@property(nonatomic,readwrite,assign)NSInteger LoginID;
@property(nonatomic,readwrite,strong)NSString *LoginNikename;
@property(nonatomic,readwrite,strong)NSString *LoginAccount;
@property(nonatomic,readwrite,strong)NSString *LoginPassword;
@property(nonatomic,readwrite,assign)NSInteger LoginAges;
@property(nonatomic,readwrite,assign)NSInteger LoginSexs;
@end

@implementation LoginSuccess

/*
  全局变量
 */
BOOL isClickFirst = false;
//负责确定pickView中的数据
NSInteger ageHuandreds =0;
NSInteger ageTen = 0;
NSInteger ageBit = 0;
NSInteger Age=0;
#pragma Mark --- 显示头像大图,同时可以用来更新数据
-(void)showBigAvatar{
    //根据给定的ID来显示对应的大头像
    NSLog(@"当前登陆者的ID是：%ld",self.WhoID);
    
    NSString *path =[NSHomeDirectory() stringByAppendingString:@"/Documents/user.sqlite"];
    self.dbPath = path;
    NSLog(@"%@",self.dbPath);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    
    _LoginData = [[NSMutableArray alloc]init];
    
    if ([db open]) {
        //查找对应的数据
        FMResultSet *result = [db executeQueryWithFormat:@"select *from userdata where id = %ld",self.WhoID];
        NSLog(@"result =%@",result);
        while ([result next]) {
            NSInteger LoginID = [result intForColumn:@"id"];
            NSString *LoginAccount = [result stringForColumn:@"Account"];
            NSString *LoginPassword = [result stringForColumn:@"Password"];
            NSInteger LoginSex = [result intForColumn:@"Sex"];
            NSString *LoginAvatar = [result stringForColumn:@"Avatar"];
            NSInteger LoginAge = [result intForColumn:@"Age"];
            NSString *LoginNikeName = [result stringForColumn:@"Nickname"];
            
            NSLog(@"(%ld,%@,%@,%ld,%@,%ld,%@)",LoginID,LoginAccount,LoginPassword,LoginSex,LoginAvatar,LoginAge,LoginNikeName);
            
            //加载大头像背景
            [self loadBigAvatar:LoginAvatar];
            //加载年龄和性别
            [self loadAgeAndSex:LoginSex age:LoginAge];
            
            //赋值
            self.LoginID = LoginID;
            self.LoginNikename = LoginNikeName;
            self.LoginAccount = LoginAccount;
            self.LoginPassword = LoginPassword;
            self.LoginAges = LoginAge;
            self.LoginSexs =LoginSex;
            
            
     
        }
    }else{
        NSLog(@"打开失败");
    }
    
    //标题设置为玩家昵称
    self.title = self.LoginNikename;
    
    [db close];
}
//加载大图
-(void)loadBigAvatar:(NSString *)avatar{
    if ([avatar isEqualToString:@"A1"]) {
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar1.jpg"];
    }else if ([avatar isEqualToString:@"A2"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar2.jpg"];
    }else if ([avatar isEqualToString:@"A3"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar3.jpg"];
    }else if ([avatar isEqualToString:@"A4"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar4.jpg"];
    }else if ([avatar isEqualToString:@"A5"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar5.jpg"];
    }else if ([avatar isEqualToString:@"A6"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar6.jpg"];
    }else if ([avatar isEqualToString:@"A7"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar7.jpg"];
    }else if ([avatar isEqualToString:@"A8"]){
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar8.jpg"];
    }else{
        self.showAllAvatar.image = [UIImage imageNamed:@"Avatar9.jpg"];
    }
}
//加载年龄和性别
-(void)loadAgeAndSex:(NSInteger )sex age:(NSInteger )age{
    //语法糖
    self.loginAge.text = @(age).stringValue;
    switch (sex) {
        case 0:
            self.loginSex.text = @"女";
            break;
        case 1:
            self.loginSex.text = @"男";
            break;
        case 2:
            self.loginSex.text = @"保密";
        default:
            break;
    }
    
}
#pragma Mark --- 改变登陆者的头像
-(void)setUserAvatar{
    
    if (isClickFirst ==false) {
        isClickFirst = !isClickFirst;
        [UIView animateWithDuration:1.0f animations:^{
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 300)];
            view.center = self.view.center;
            view.tag = 101;
            view.backgroundColor = [UIColor grayColor];
            [self.view addSubview:view];
            //添加标准瀑布流图片选择
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
            layout.minimumLineSpacing =0;
            layout.minimumInteritemSpacing =0.0f;
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            UICollectionView *collection = [[UICollectionView alloc]initWithFrame:view.bounds collectionViewLayout:layout];
            
            collection.dataSource =self;
            collection.delegate =self;
            
            //注册cell
            [collection registerClass:[ViewInViewCell class] forCellWithReuseIdentifier:@"cell"];
            //添加到view上
            [view addSubview:collection];
        }];
    }else{
        NSLog(@"该按钮现在失效");
    }
    
}
#pragma Mark --- UICollectionView协议相关
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _AvatarData.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100, 100);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ViewInViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    NSString *number = _AvatarData[indexPath.row];
    cell.backgroundImage.image = [UIImage imageNamed:number];
    cell.label.text = [NSString stringWithFormat:@"可选头像%lu",indexPath.row+1];
    
    return cell;
}
//响应事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是:%ld",indexPath.row);
    
    //先改变背景图片，然后改变数据库中的数据
    NSString *BigImage;
    switch (indexPath.row) {
        case 0:
            BigImage = @"A1";
            break;
        case 1:
            BigImage = @"A2";
            break;
        case 2:
            BigImage = @"A3";
            break;
        case 3:
            BigImage = @"A4";
            break;
        case 4:
            BigImage = @"A5";
            break;
        case 5:
            BigImage = @"A6";
            break;
        case 6:
            BigImage = @"A7";
            break;
        case 7:
            BigImage = @"A8";
            break;
        case 8:
        case 9:
            BigImage = @"A9";
            break;
        default:
            break;
    }
    //调用更改视图
    [self loadBigAvatar:BigImage];
    
    //更改数据库数据
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSLog(@"打开数据库进行更改");
        //对当前的表进行修改
        NSLog(@"BigImage = %@",BigImage);
        
        [db setShouldCacheStatements:YES];
 
        BOOL isUpdate = [db executeUpdateWithFormat:@"update userdata set Avatar = %@ where id = %ld",BigImage,self.LoginID];
    
        if (isUpdate){
            NSLog(@"更新成功");
            FMResultSet *result = [db executeQueryWithFormat:@"select *from userdata where id = %ld",self.LoginID];
            while ([result next]) {
                NSInteger ID = [result intForColumn:@"id"];
                NSString *Avatar = [result stringForColumn:@"Avatar"];
                NSString *Account = [result stringForColumn:@"Account"];
                NSLog(@"ID = %ld,Avatar = %@,Account =%@",ID,Avatar,Account);
                //把修改的值回传给上一个界面 -->委托回调
                [_delegate showAvatar:Avatar];
            }
        }else{
            NSLog(@"更新失败");
        }
    }else{
        NSLog(@"数据库打开失败，无法更改");
    }
    
    //选择后移除UIView
    UIView *view = (UIView *)[self.view viewWithTag:101];
    [view removeFromSuperview];
    isClickFirst = !isClickFirst;
    
    [db close];
}
#pragma Mark --- tableview显示相关详细信息
-(void)tableViewToShowInformation{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,290, 320, 270) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.alpha = 0.8;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _textLabelArray = [NSMutableArray arrayWithObjects:@"昵称",@"账号ID",@"账户名",@"账户密码",@"性别",@"年龄", nil];
    _AvatarData = [NSMutableArray arrayWithObjects:@"A1.png",@"A2.png",@"A3.png",@"A4.png",@"A5.png",@"A6.png",@"A7.png",@"A8.png",@"A9.png",@"A10.png",nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textLabelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat Height = _tableView.frame.size.height/_textLabelArray.count;
    return Height;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *SID = @"id";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:SID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SID];
    }
    
    cell.textLabel.text = _textLabelArray[indexPath.row];
    NSString *strSex;
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = self.LoginNikename;
            break;
        case 1:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.LoginID];
            break;
        case 2:
            cell.detailTextLabel.text = self.LoginAccount;
            break;
        case 3:
            cell.detailTextLabel.text = self.LoginPassword;
            break;
        case 4:
            switch (self.LoginSexs) {
                case 0:
                    strSex = @"女";
                    break;
                case 1:
                    strSex = @"男";
                    break;
                case 2:
                    strSex = @"保密";
                    break;
                default:
                    break;
            }
            cell.detailTextLabel.text = strSex;
            break;
        case 5:
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",self.LoginAges];
            break;
        default:
            break;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%ld",self.LoginAges);
        NSLog(@"%ld",self.LoginSexs);
        NSLog(@"%ld",self.LoginID);
    });
    return cell;
}
//响应tableView按钮的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self pushViewInCenter:@"请输入你的昵称" Type:0];
            break;
        case 1:
            [self pushAlertController:@"操作受限" andMessage:@"你无权更改账号ID"];
            break;
        case 2:
            [self pushAlertController:@"操作受限" andMessage:@"你无权更改账号名"];
            break;
        case 3:
            [self pushViewInCenter:@"请输入你的密码" Type:1];
            break;
        case 4: //性别 --->单选
            [self pushViewInCenter:@"请确定你的性别" Type:2];
            break;
        case 5: //年龄 --->UIPickView
            [self pushViewInCenter:@"请确定你的年龄" Type:3];
            break;
        default:
            break;
    }
}
#pragma Mark --- 系统弹出提示
-(void)pushAlertController:(NSString *)title andMessage:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma Mark --- 系统弹出视图
-(void)pushViewInCenter:(NSString *)tipInformation Type:(NSInteger)type{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 180, 320, 230)];
    view.tag = 102;
    view.backgroundColor = [UIColor grayColor];
    view.alpha =0.8;
    [self.view addSubview:view];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    tipLabel.text = tipInformation;
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:tipLabel];
    
    //根据传进来的类型确定后续添加UIPickView
    switch (type) {
        case 0: //---->添加输入框以用来输入昵称
            [self uiTextField:0];
            break;
        case 1: //---->添加输入框以用来输入密码
            [self uiTextField:1];
            break;
        case 2: //---->添加按钮响应选择
            [self selectLoginSex];
            break;
        case 3: //---->调用UIPickView操作
            [self creatUIPickView];
            break;
        default:
            break;
    }
}
#pragma Mark --- 输入框事件
-(void)uiTextField:(NSInteger) type{
    UIView *view = (UIView *)[self.view viewWithTag:102];
    NSInteger Field_Y = view.frame.size.height/2-60;
    NSInteger Field_W = view.frame.size.width/2+20;
    NSInteger Field_H = 40;
    
    if (type ==0) { //昵称
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, Field_Y, Field_W, Field_H)];
        textField.backgroundColor = [UIColor whiteColor];
        //按键类型
        textField.returnKeyType = UIReturnKeyDefault;
        //无文字不可选
        textField.enablesReturnKeyAutomatically =YES;
        //风格
        [textField setBorderStyle:UITextBorderStyleRoundedRect];
        textField.placeholder = @"请输入你的新昵称";
        [view addSubview:textField];
        textField.delegate = self;
        textField.tag = 12;
    }else{          //密码
        for (NSInteger i=0; i<2; i++) {
            UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(20, Field_Y+i*Field_H, Field_W, Field_H)];
            textField.backgroundColor = [UIColor whiteColor];
            //按键类型
            textField.returnKeyType = UIReturnKeyDefault;
            //无文字不可选
            textField.enablesReturnKeyAutomatically =YES;
            //风格
            [textField setBorderStyle:UITextBorderStyleRoundedRect];
            textField.tag = 10+i;
            textField.delegate = self;
            if (i==0) {
                textField.placeholder = @"请输入你的新密码";
            }else{
                textField.placeholder = @"再次输入你的新密码";
            }
            [view addSubview:textField];
        }
    }

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(Field_W+50, Field_Y+8+type*Field_H, 60, 20);
    btn.layer.cornerRadius = 10;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview:btn];
    
 /*
    //监控键盘状态 --->下版本使用
    //键盘即将弹出时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    //键盘即将消失时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  */
}
-(void)click{
    UIView *view = (UIView *)[self.view viewWithTag:102];
    [view removeFromSuperview];
    
    [self resignFirstResponder];
}
#pragma Mark --- 性别选择
-(void)selectLoginSex{
    
    UIView *view = (UIView *)[self.view viewWithTag:102];
    
    NSArray *array = @[@"男",@"女",@"保密"];
    
    for (NSInteger i=0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(50+i*80,30,60, 20);
        btn.layer.cornerRadius = 10;
        btn.backgroundColor = [UIColor greenColor];
        btn.tag = 20+i;
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(clickLoginSex:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:btn];
    }
    
    [self.view addSubview:view];
}
-(void)clickLoginSex:(UIButton *)btn{
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    [db open];
    
    NSInteger sex =0;
    switch (btn.tag) {
        case 20: //男
            sex =1;
            self.loginSex.text = @"男";
            break;
        case 21: //女
            sex =0;
            self.loginSex.text = @"女";
            break;
        case 22: //保密
            sex =2;
            self.loginSex.text = @"保密";
            break;
        default:
            break;
    }
    self.LoginSexs =sex;
    
    //修改数据
    BOOL update = [db executeUpdateWithFormat:@"update userdata set Sex = %ld where id = %ld",sex,self.LoginID];
    if (update) {
        NSLog(@"性别修改成功");
        [_tableView reloadData];
    }else{
        NSLog(@"性别修改失败");
    }
    
    [db close];
    
    UIView *view = (UIView *)[self.view viewWithTag:102];
    
    [view removeFromSuperview];
}
#pragma Mark --- 键盘响应
/*
  textfield协议 --->点击了return以后
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    //点击return回收键盘
    [textField resignFirstResponder];
    
    //昵称的输入
    UITextField *Nickname = (UITextField *)[self.view viewWithTag:12];
    
    //密码输入
    UITextField *newPassword = (UITextField *)[self.view viewWithTag:10];
    UITextField *repeatPassword = (UITextField *)[self.view viewWithTag:11];
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        //判断输入的昵称还是账号
        if (Nickname !=nil) {
            NSLog(@"修改昵称");
            BOOL update = [db executeUpdateWithFormat:@"update userdata set Nickname = %@ where id = %ld",Nickname.text,self.LoginID];
            if (update) {
                [self pushAlertController:@"昵称修改" andMessage:@"昵称修改成功"];
                self.LoginNikename = Nickname.text;
                self.title = self.LoginNikename;
            }
            //刷新表格
            [_tableView reloadData];
        }else{
            NSLog(@"修改密码");
            if ([newPassword.text isEqualToString:repeatPassword.text]) {
                NSLog(@"密码相同");
                BOOL update = [db executeUpdateWithFormat:@"update userdata set Password = %@ where id = %ld",repeatPassword.text,self.LoginID];
                if (update) {
                    [self pushAlertController:@"密码修改" andMessage:@"修改成功"];
                    self.LoginPassword = repeatPassword.text;
                }
            }else{
                [self pushAlertController:@"密码修改" andMessage:@"前后输入的密码不一致，请重新输入"];
            }
            //刷新表格
            [_tableView reloadData];
        }
    }else{
        NSLog(@"数据库打开失败");
    }
    //调用关闭视图
    [self click];
    //委托实现方法
    [_delegate LoginOut:true];
    //关闭数据库
    [db close];
    return YES;
}
/*
   //键盘状态
-(void)keyboardWillShow:(NSNotification *)notification{
    //键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSInteger Height = keyboardRect.size.height;
    NSLog(@"Height = %ld",Height);
    
    //将UIView往上移
    UIView *view = (UIView *)[self.view viewWithTag:102];
    
    NSInteger newView_Y = view.frame.origin.y - Height/2;
    NSInteger view_X = view.frame.origin.x;
    NSInteger view_W = view.frame.size.width;
    NSInteger view_H = view.frame.size.height;
    
    [UIView animateWithDuration:1.0f animations:^{
        view.frame =CGRectMake(view_X, newView_Y, view_W, view_H);
    }];
    
}
-(void)keyboardWillHide:(NSNotification *)notification{
    //键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSInteger Height = keyboardRect.size.height;
    NSLog(@"Height = %ld",Height);
    
    //将UIView下移到原本位置
    UIView *view = (UIView *)[self.view viewWithTag:102];
    
    NSInteger newView_Y = view.frame.origin.y + Height/2;
    NSInteger view_X = view.frame.origin.x;
    NSInteger view_W = view.frame.size.width;
    NSInteger view_H = view.frame.size.height;
    
    [UIView animateWithDuration:1.0f animations:^{
        view.frame =CGRectMake(view_X, newView_Y, view_W, view_H);
    }];
}
*/
#pragma Mark --- UIPickView及其相关
-(void)creatUIPickView{
    
    //加载数据
    self.number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
    UIView *view = (UIView *)[self.view viewWithTag:102];
    
    NSInteger PickView_Y = view.frame.size.height/2-60;
    NSInteger PickView_W = view.frame.size.width/2;
    NSInteger PickView_H = 80;
    UIPickerView *pickView = [[UIPickerView alloc]init];
    
    pickView.frame = CGRectMake(20, PickView_Y,PickView_W, PickView_H);
    pickView.backgroundColor = [UIColor clearColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    
    
    for (NSInteger i=0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(PickView_W+20+i*60, PickView_Y+20, 60, 40);
        btn.backgroundColor = [UIColor redColor];
        btn.layer.cornerRadius = 10;
        btn.tag = 1+i;
        
        if (i ==0) {
            [btn setTitle:@"确定" forState:UIControlStateNormal];
        }else{
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(PickViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    [view addSubview:pickView];
}
//多少组
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
//每组中有多少元素
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.number.count;
}
//每行元素的高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 80;
}
//定义内容
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc]init];
    label.text = self.number[row];
    return label;
}
//选中某行后回调方法，获得选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        ageHuandreds = row;
    }else if (component ==1){
        ageTen = row;
    }else{
        ageBit = row;
    }
    Age = ageHuandreds*100+ageTen*10+ageBit*1;

}
//点击响应事件
-(void)PickViewClick:(UIButton *)btn{
    //移除当前UIView
    UIView *view =(UIView *)[self.view viewWithTag:102];
    [view removeFromSuperview];
    
    if (btn.tag ==1) {
        //更新数据库
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            //更新数据
            BOOL update = [db executeUpdateWithFormat:@"update userdata set Age = %ld where id = %ld",Age,self.LoginID];
            if (update) {
                [self pushAlertController:@"更新成功" andMessage:@"成功设置年龄"];
                //实时显示数据
                self.loginAge.text = @(Age).stringValue;
                self.LoginAges = Age;
                //刷新表格
                [_tableView reloadData];
                //清空数据
                ageHuandreds = 0;
                ageTen = 0;
                ageBit = 0;
                Age =0;
            }else{
                [self pushAlertController:@"更新失败" andMessage:@"年龄设置失败"];
            }
        }else{
            [self pushAlertController:@"失败" andMessage:@"数据库打开失败,请重试"];
        }
        [db close];
    }else{
        return;
    }
}
#pragma Mark --- 基础操作
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //设置导航栏全透明
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    //添加导航栏按钮
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"....." style:UIBarButtonItemStylePlain target:self action:@selector(setUserAvatar)];
    self.navigationItem.rightBarButtonItem = right;
    
    
    //图片设置
    [self showBigAvatar];
    
    [self tableViewToShowInformation];
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
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
