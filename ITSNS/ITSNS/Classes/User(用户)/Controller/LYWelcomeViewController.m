//
//  LYWelcomeViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "LYRegisterViewController.h"
#import "LYWelcomeViewController.h"
#import "LYLoginViewController.h"
@interface LYWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LYWelcomeViewController
- (IBAction)registerAction:(id)sender {
     LYRegisterViewController *vc = [[LYRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

    
}
- (IBAction)loginAction:(id)sender {
    LYLoginViewController *vc = [[LYLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.registerBtn.layer.borderWidth = 1;
    self.registerBtn.layer.cornerRadius = self.loginBtn.layer.cornerRadius= self.registerBtn.bounds.size.height/2;
    self.registerBtn.layer.masksToBounds = self.registerBtn.layer.masksToBounds = YES;
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
