//
//  LYUserInfoViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRUserHeaderView.h"
#import "TRDetailViewController.h"
#import "LYUserInfoViewController.h"
#import "TRITObject.h"
#import "LYHomeCell.h"
#import "SVPullToRefresh.h"
@interface LYUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)NSMutableArray *itObjs;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSData *imageData;
@end

@implementation LYUserInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  

    
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    
    
    //要在下拉刷新事件之前添加 让内容往下显示
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    [tableView registerNib:[UINib nibWithNibName:@"LYHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    //添加刷新事件
    [tableView addPullToRefreshWithActionHandler:^{
        
        [self loadObjs];
        
    }];
    
    
    
    //触发下拉刷新事件
    [tableView triggerPullToRefresh];
    
    //添加 上拉加载事件
    [tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreObjs];
    }];
    
    
    
    TRUserHeaderView *hv = [[NSBundle mainBundle]loadNibNamed:@"TRUserHeaderView" owner:self options:0][0];
    hv.user = self.user;
    
    self.tableView.tableHeaderView = hv;
    
  
    
    //给用户头像添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [hv.headIV addGestureRecognizer:tap];
    
    
    //检查是否是好友
    
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
    
 
           
            for (EMBuddy *buddy in buddyList) {
                NSString *username = buddy.username;
                if ([username isEqualToString:self.user.username]) {//判断是否是好友
                    
                    [hv.myBtn setTitle:@"聊天" forState:UIControlStateNormal];
                    hv.myBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    break;
                }
                
            }
            
         
            
            
            
        }
    } onQueue:nil];
    
    //判断是否是自己
    
    if ([self.user.username isEqualToString:[BmobUser currentUser].username]) {
        
        hv.myBtn.enabled = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:self action:@selector(editAction)];
    }

}
-(void)tapAction{
    
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(void)editAction{
        TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Edit"]) {
        
        
        
        hv.nickTF.enabled = YES;
        hv.nickTF.backgroundColor = LYGreenColor;
        
        hv.headIV.userInteractionEnabled = YES;
        hv.headIV.layer.borderColor = LYGreenColor.CGColor;
        hv.headIV.layer.borderWidth = 3;
        
        
        
        self.navigationItem.rightBarButtonItem.title = @"Save";
        
    }else{//保存操作
        
        hv.nickTF.enabled = NO;
        hv.nickTF.backgroundColor = [UIColor clearColor];
        hv.headIV.layer.borderWidth = 0;
        
        
        NSString *currentNick = [self.user objectForKey:@"nick"];
        
        if (self.imageData||![hv.nickTF.text isEqualToString:currentNick]) {
            
            //判断是否有图片
            if (self.imageData) {
                //上传图片
                BmobFile *file = [[BmobFile alloc]initWithFileName:@"a.jpg" withFileData:self.imageData];
                [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        
                        BmobUser *user = [BmobUser currentUser];
                        //更新头像地址
                        [user setObject:file.url forKey:@"headPath"];
                        [user setObject:hv.nickTF.text forKey:@"nick"];
                        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                           
                            NSLog(@"头像保存成功！");
                                [self.tableView triggerPullToRefresh];
                            //让headView内容更新
                            hv.user = [BmobUser currentUser];
                        }];
                        
                    }
                } withProgressBlock:^(CGFloat progress) {
                    NSLog(@"%lf",progress);
                }];
                
            }else{//没有头像只修改 nick
                
                BmobUser *user = [BmobUser currentUser];
                //更新用户nick
                [user setObject:hv.nickTF.text forKey:@"nick"];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    NSLog(@"用户名保存成功！");
                    
                    [self.tableView triggerPullToRefresh];
                    //让headView内容更新
                    hv.user = [BmobUser currentUser];
                }];

                
                
                
            }
            
            
            
        }
        
        
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    }
    

    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView triggerPullToRefresh];
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    NSLog(@"%@",self.user);
        NSLog(@"%@",[BmobUser currentUser]);
    //判断只有是显示自己信息的时候更新 表头数据
    if ([self.user.username isEqualToString:[BmobUser currentUser].username]) {
        
        hv.user = [BmobUser currentUser];
    }
    
}

-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@"0"];
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //设置请求条数
    query.limit = 10;
    //只查询当前用户的消息
    [query whereKey:@"user" equalTo:self.user];

    //设置排序
    [query orderByDescending:@"updatedAt"];
    //    设置包含user
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];
    
}
-(void)loadObjs{
    
    
    
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@"0"];
    
    //只查询当前用户的消息
    [query whereKey:@"user" equalTo:self.user];
    
    //设置请求条数
    query.limit = 10;
    //设置排序
    [query orderByDescending:@"updatedAt"];
    //    设置包含user
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        //请求到数据后 初始化数组
        self.itObjs = [NSMutableArray array];
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
    
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itObjs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    cell.itObj = self.itObjs[indexPath.row];
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //计算每行的高度
    TRITObject *itObj = self.itObjs[indexPath.row];
    
    
    
    return itObj.contentHeight + 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRDetailViewController *vc = [TRDetailViewController new];
    
    vc.itObj = self.itObjs[indexPath.row];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    self.tableView.clipsToBounds = NO;
}

//当SV拖动的时候会不停的进入此方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    
    [hv updateSubViewsWithOffset:scrollView.contentOffset.y];
    
    
}

#pragma mark 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageData = UIImageJPEGRepresentation(image, .5);
    
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    hv.headIV.image = image;
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
