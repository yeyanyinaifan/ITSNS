//
//  LYSettingsViewController.m
//  蓝懿微博
//
//  Created by Ivan on 15/12/24.
//  Copyright © 2015年 Ivan. All rights reserved.
//
#import "LYWelcomeViewController.h"
#import "LYSettingsViewController.h"

@interface LYSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSArray *groups;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation LYSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groups = [NSMutableArray array];
    
    NSArray *g1 = @[@[@"清除缓存",@"hot_status"],@[@"找人",@"find_people"]];
    
    NSArray *g2 = @[@[@"游戏中心",@"game_center"],@[@"周边",@"near"],@[@"应用",@"app"]];
    
    NSArray *g3 = @[@[@"视频",@"video"],@[@"音乐",@"music"],@[@"电影",@"movie"]];
    NSArray *g4 = @[@[@"切换账户",@"user"]];
    self.groups = @[g1,g2,g3,g4];
    
    UITableView *tv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tv.dataSource = self;
    tv.delegate = self;
    [self.view addSubview:tv];
    self.tableView = tv;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *group = self.groups[section];
    return group.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    NSArray *group = self.groups[indexPath.section];
    
    NSArray *item = group[indexPath.row];
    cell.textLabel.text = item[0];
    cell.imageView.image = [UIImage imageNamed:item[1]];
    
    
    return cell;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
            
            NSString *message = [NSString stringWithFormat:@"您确认清除%.2fM缓存吗？",totalSize/1024.0/1024];

            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //清除内存缓存
                [[SDImageCache sharedImageCache]clearMemory];
                //清除磁盘缓存
                 [[SDImageCache sharedImageCache]clearDisk];
            }];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:action1];
            [ac addAction:action2];
            
            [self presentViewController:ac animated:YES completion:nil];
            
        }];
        
    }
    
    
    if (indexPath.section == 3) {
        [BmobUser logout];
        [[EasemobManager shareManager]logout];
        LYWelcomeViewController *vc = [[LYWelcomeViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:navi animated:YES completion:nil];
        
    }

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
