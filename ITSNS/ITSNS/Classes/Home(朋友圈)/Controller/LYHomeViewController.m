//
//  LYHomeViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "AFNetworkReachabilityManager.h"
#import "TRDetailViewController.h"
#import "LYHomeCell.h"
#import "Bmob.h"
#import "LYHomeViewController.h"
#import "AppDelegate.h"
#import "TRITObject.h"
#import "SVPullToRefresh.h"
@interface LYHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *itObjs;
@property (nonatomic, strong)AFNetworkReachabilityManager *manager;
@end

@implementation LYHomeViewController

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
    
    
    
  
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
        if (self.itObjs.count==0) {
            
            
            [self.tableView triggerPullToRefresh];
        }
 
    
    
    
    
    
    //检测网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    self.manager = manager;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch ((int)status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                //没网并且没有数据的时候才需要加装本地数据
                if (self.itObjs.count==0) {
                    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/itObjs.arch"];
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    //如果有数据
                    if (data) {
                        self.itObjs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        
                        [self.tableView reloadData];
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi网络");
                
                
                
                break;
        }
        
        //        typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
        //
        //
        //            AFNetworkReachabilityStatusUnknown          = -1,//未识别网络
        //            AFNetworkReachabilityStatusNotReachable     = 0,//无网络
        //            AFNetworkReachabilityStatusReachableViaWWAN = 1,//移动网络
        //            AFNetworkReachabilityStatusReachableViaWiFi = 2,//wifi
        //        };
        //
        
    }];
    //开始监测
    [manager startMonitoring];

    
    
    
    
    //实现浏览量功能 返回页面时刷新选中的某一行
    //判断是否有选中
    if (self.tableView.indexPathForSelectedRow) {
        
        [self.tableView reloadRowsAtIndexPaths:@[self.tableView.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
}

-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@(self.type).stringValue];
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //设置请求条数
    query.limit = 10;
    
    //设置排序
    switch (self.type) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1://问题
            [query orderByDescending:@"showCount"];
            break;
        case 2://项目
            [query orderByDescending:@"commentCount"];
            break;
    }
    
    //    设置包含user
    [query includeKey:@"user"];
    
    
    //查询指定某个用户的
    if (self.user) {
        
        [query whereKey:@"user" equalTo:self.user];
    }
    
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
   
   //判断是否有网络 无网络就不需要刷新了
    NSLog(@"%ld",self.manager.networkReachabilityStatus);
    if (self.manager.networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable) {
        [self.tableView.pullToRefreshView stopAnimating];
        
        return;
    }
    

    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //设置查询条件为 type = 0
    [query whereKey:@"type" equalTo:@(self.type).stringValue];
    //设置请求条数
    query.limit = 10;
    //设置排序
    switch (self.type) {
        case 0:
            [query orderByDescending:@"createdAt"];
            break;
        case 1://问题
            [query orderByDescending:@"showCount"];
            break;
        case 2://项目
            [query orderByDescending:@"commentCount"];
            break;
    }
  
    
    
    
//    设置包含user
    [query includeKey:@"user"];
    
    //查询指定某个用户的
    if (self.user) {
        
        [query whereKey:@"user" equalTo:self.user];
    }
    
    
    
    
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
    
   
    if (self.itObjs.count>0) {
        //把数据保存
        NSData *itObjsData = [NSKeyedArchiver archivedDataWithRootObject:self.itObjs];
        
        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/itObjs.arch"];
        [itObjsData writeToFile:path atomically:YES];
    }
    
    
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
    
    [vc.itObj addShowCount];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
