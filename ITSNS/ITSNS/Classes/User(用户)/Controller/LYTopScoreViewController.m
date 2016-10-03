//
//  LYTopScoreViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/22.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "LYTopScoreViewController.h"
#import "LYTopScoreUserCell.h"
#import "LYUserInfoViewController.h"
@interface LYTopScoreViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSArray *users;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation LYTopScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"积分排行";
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LYTopScoreUserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    //创建查询请求
    BmobQuery *bquery = [BmobUser query];
    //让查询结果降序排序
    [bquery orderByDescending:@"Score"];

    
    //执行查询请求
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.users = array;
        
        
        
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYTopScoreUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.user = self.users[indexPath.row];
    //显示第几名
    cell.numberLabel.text = [NSString stringWithFormat:@"No.%02ld",indexPath.row+1];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    LYUserInfoViewController *vc = [[LYUserInfoViewController alloc]init];
    vc.user = self.users[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



@end
