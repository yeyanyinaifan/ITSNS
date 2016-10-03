//
//  LYMainTabbarController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRSendingViewController.h"
#import "SphereMenu.h"
#import "LYMainTabbarController.h"
#import "LYSettingsViewController.h"
#import "LYMainTabbarController.h"
#import "LYHomeViewController.h"
#import "LYLocationViewController.h"
#import "LYProjectViewController.h"
#import "LYQViewController.h"
#import "LYMessageListViewController.h"
#import "LYFriendsViewController.h"
#import "LYMainNavigatoinController.h"
@interface LYMainTabbarController ()<SphereMenuDelegate>
@property (nonatomic, strong)SphereMenu *sphereMenu;
@end

@implementation LYMainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
  
    LYHomeViewController *hvc = [[LYHomeViewController alloc]init];
    LYMessageListViewController *mlvc = [[LYMessageListViewController alloc]init];
    LYFriendsViewController *fvc = [[LYFriendsViewController alloc]init];
    LYLocationViewController *lvc = [[LYLocationViewController alloc]init];
    LYHomeViewController *qvc = [[LYHomeViewController alloc]init];
    qvc.type = 1;
    
    LYHomeViewController *pvc = [[LYHomeViewController alloc]init];
    pvc.type = 2;
    
    LYSettingsViewController *svc = [[LYSettingsViewController alloc]init];
    NSArray *titles = @[@"朋友圈",@"消息列表",@"好友列表",@"位置服务",@"热门问题",@"热门项目",@"设置页面",];
    hvc.title = titles[0];
    mlvc.title = titles[1];
    fvc.title = titles[2];
    lvc.title = titles[3];
    qvc.title = titles[4];
    pvc.title = titles[5];
    svc.title = titles[6];
    self.viewControllers = @[LYNavi(hvc),LYNavi(mlvc),LYNavi(fvc),LYNavi(lvc)];
    
    [self addChildViewController:LYNavi(qvc)];
    [self addChildViewController:LYNavi(pvc)];
    [self addChildViewController:LYNavi(svc)];
   
    
    self.tabBar.hidden = YES;
    
    [self addSendButtons];
    
    //检测未读
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkingUnReadCount) userInfo:nil repeats:YES];
    [self checkingUnReadCount];
}

-(void)checkingUnReadCount{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"UnRead"];
    
    [bq whereKey:@"toUser" equalTo:[BmobUser currentUser]];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        int count = 0;
        for (BmobObject *obj in array) {
            count += [[obj objectForKey:@"count"]intValue];
            
        }
        
        //把未读数量通过广播传递出去
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UnReadNotification" object:@(count)];
        
        
        
    }];
    
}

-(void)addSendButtons{
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(267, 40)
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [sphereMenu addGestureRecognizer:pan];
    self.sphereMenu = sphereMenu;
    
    
}
-(void)panAction:(UIPanGestureRecognizer *)pan{
    
    pan.view.center = [pan locationInView:self.view];
    
    [self.sphereMenu  shrinkSubmenu];
}

- (void)sphereDidSelected:(int)index{
    NSLog(@"%d",index);
    
    
    
    TRSendingViewController *vc = [TRSendingViewController new];
    vc.type = @(index).stringValue;
    //跳转到发送页面 带导航控制器
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *nick = [[BmobUser currentUser]objectForKey:@"nick"];
    NSString *headPath = [[BmobUser currentUser]objectForKey:@"headPath"];
    if (!nick||!headPath) {
        
        AddNameAndPicViewController *vc = [AddNameAndPicViewController new];
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
        
    }

}

@end
