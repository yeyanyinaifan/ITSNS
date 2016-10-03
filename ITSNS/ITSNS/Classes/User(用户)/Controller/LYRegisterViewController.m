//
//  LYRegisterViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//


#import "LYRegisterViewController.h"
#import "Bmob.h"
#import "AppDelegate.h"

@interface LYRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;

@property (nonatomic,strong)BmobUser *user;

@end
extern NSString *DidLoginWeiboNotification;
@implementation LYRegisterViewController

- (IBAction)registerAction:(id)sender {
   
    self.user = [BmobUser new];
    self.user.username = self.userNameTF.text;
    self.user.password = self.pwTF.text;
    self.user.email = self.emailTF.text;
    
    [self.user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
   
        
        if (succeeded) {

            //注册环信
            [[EasemobManager shareManager] registerWithName:self.user.username andPW:@"admin"];
            
            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [app showHomeVC];

            
        }else{
            NSLog(@"%@",error);
        }
        
        
        
    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置bar的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"注册";
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
   
    //判断是否有输入内容
    if (self.emailTF.text.length>0&&self.userNameTF.text.length>0&&self.pwTF.text.length>0) {
        self.registerBtn.backgroundColor = LYGreenColor;
        self.registerBtn.enabled = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.emailTF.text.length>0&&self.userNameTF.text.length>0&&self.pwTF.text.length>0) {
        self.registerBtn.backgroundColor = LYGreenColor;
        self.registerBtn.enabled = YES;
    }else{
        self.registerBtn.enabled = NO;
        self.registerBtn.backgroundColor = [UIColor lightGrayColor];
    }
    
    
    
    
}

@end
