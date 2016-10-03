//
//  LYLeftMenuViewController.m
//  ITSNS
//
//  Created by Ivan on 16/3/2.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "XHDrawerController.h"
#import "LYLeftMenuViewController.h"
#import "AppDelegate.h"
@interface LYLeftMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableVeiw;
@property (nonatomic, strong)NSArray *titles;
@end
static NSString *identifier = @"cell";
@implementation LYLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableVeiw registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    self.titles = @[@"朋友圈",@"消息列表",@"好友列表",@"位置服务",@"热门问题",@"热门项目",@"设置页面",];
}


#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    //需要先创建一个背景View 才能设置颜色
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = LYGreenColor;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //先得到tabbarController
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.tabbarController.selectedIndex = indexPath.row;
    [self.drawerController closeDrawerAnimated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
