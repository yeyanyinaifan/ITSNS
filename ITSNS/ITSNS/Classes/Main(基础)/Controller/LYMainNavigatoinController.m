//
//  LYMainNavigatoinController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRUnReadTableViewController.h"
#import "LYTopScoreViewController.h"
#import "LYHomeViewController.h"
#import "LYUserInfoViewController.h"
#import "RNFrostedSidebar.h"
#import "LYMainNavigatoinController.h"
#import "XHDrawerController.h"
#import "TRMyItem.h"
@interface LYMainNavigatoinController ()<RNFrostedSidebarDelegate>
@end

@implementation LYMainNavigatoinController

-(void)viewDidLoad{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //判断只显示第一级页面的时候才添加
    if (self.viewControllers.count==1) {
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleDone target:self action:@selector(menuAction)];
        //得到导航控制器里面
        self.topViewController.navigationItem.leftBarButtonItem = menuItem;
        
        TRMyItem *myItem = [[[NSBundle mainBundle]loadNibNamed:@"TRMyItem" owner:self options:nil]firstObject];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:myItem];
        [myItem.userBtn addTarget:self action:@selector(showSliderBar) forControlEvents:UIControlEventTouchUpInside];
       
        
        
        //得到导航控制器里面 第一个页面添加
        self.topViewController.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    
    self.navigationBar.tintColor = LYGreenColor;
}

-(void)menuAction{
    
    [self.drawerController toggleDrawerSide:XHDrawerSideLeft animated:YES completion:NULL];
}

//右侧边栏
//右侧边栏
-(void)showSliderBar{
    //通过静态修饰 让内存中只有一个tabbar
    
    NSArray *images = @[
                        [UIImage imageNamed:@"profile"],
                        [UIImage imageNamed:@"question"],
                        [UIImage imageNamed:@"globe"],
                        [UIImage imageNamed:@"star"],
                        [UIImage imageNamed:@"unread"],];
    NSArray *colors = @[
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                        [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                        [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                        [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                        ]
    ;
    
    RNFrostedSidebar *sliderBar = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:nil borderColors:colors];
    //让按钮整体往下移动
    sliderBar.contentView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    //背景颜色
    sliderBar.tintColor = [UIColor blackColor];
    //从右侧显示
    sliderBar.showFromRight = YES;
    
    //添加用户头像
    UIImageView *headIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, -50, 60, 60)];
    headIV.layer.cornerRadius = 30;
    headIV.layer.masksToBounds = YES;
    headIV.layer.borderColor = [UIColor whiteColor].CGColor;
    headIV.layer.borderWidth = 2;
    //设置用户头像
    BmobUser *user = [BmobUser currentUser];
    NSString *path = [user objectForKey:@"headPath"];
//    NSLog(@"%@",path);
    [headIV sd_setImageWithURL:[NSURL URLWithString:path]];
    
    
    [sliderBar.contentView addSubview:headIV];
    
    sliderBar.delegate = self;
    [sliderBar show];
}

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"%ld",index);
    
    switch (index) {
        case 0:
            
        {
             LYUserInfoViewController *vc = [LYUserInfoViewController new];
            vc.user = [BmobUser currentUser];
            
            [self pushViewController:vc animated:YES];
            
        }
            
            
            break;

        case 1:
            
        {
            LYHomeViewController *vc = [LYHomeViewController new];
            vc.user = [BmobUser currentUser];
            vc.type = 1;
            [self pushViewController:vc animated:YES];
            
        }
            
            
            break;

        case 2:
            
        {
            LYHomeViewController *vc = [LYHomeViewController new];
            vc.user = [BmobUser currentUser];
            vc.type = 2;
            [self pushViewController:vc animated:YES];
            
        }
            
            
            break;

        case 3:
            
        {
            LYTopScoreViewController *vc = [LYTopScoreViewController new];
           
            
            [self pushViewController:vc animated:YES];
            
        }
            
            
            break;
        case 4:
            
        {
            TRUnReadTableViewController *vc = [TRUnReadTableViewController new];
            
            [self pushViewController:vc animated:YES];
            
        }
            
            
            break;

        default:
            break;
    }
    [sidebar dismiss];
    

}





@end
