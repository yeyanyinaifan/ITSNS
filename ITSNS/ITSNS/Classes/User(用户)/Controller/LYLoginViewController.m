//
//  LYLoginViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "Bmob.h"
#import "LYLoginViewController.h"
#import "AppDelegate.h"

@interface LYLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LYLoginViewController
- (IBAction)loginAction:(id)sender {

    [BmobUser loginInbackgroundWithAccount:self.userNameTF.text andPassword:self.pwTF.text block:^(BmobUser *user, NSError *error) {
        
        if (user) {
            //登录环信
            [[EasemobManager shareManager]logingWithName:user.username andPW:@"admin"];
            
            
            
            //添加显示首页的代码
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app showHomeVC];
        }
        
        if (error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                //确定时做的事
            }];
            
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置bar的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"登陆";

      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)keyboardFrameChange:(NSNotification*)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        if (keyboardF.origin.y==LYSH) {//收键盘
            self.loginBtn.transform = CGAffineTransformIdentity;
            
        }else{//软件盘弹出的时候 把表情隐藏
            self.loginBtn.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
            
            
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
