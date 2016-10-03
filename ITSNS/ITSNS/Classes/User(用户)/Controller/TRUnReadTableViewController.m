//
//  TRUnReadTableViewController.m
//  ITSNS
//
//  Created by tarena on 16/7/7.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRITObject.h"
#import "TRDetailViewController.h"
#import "TRUnReadTableViewController.h"

@interface TRUnReadTableViewController ()
@property (nonatomic, strong)NSArray *unreads;
@end

@implementation TRUnReadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    BmobQuery *query = [BmobQuery queryWithClassName:@"UnRead"];
    [query whereKey:@"toUser" equalTo:[BmobUser currentUser]];
    //包含source字段详情
    [query includeKey:@"source"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.unreads = array;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.unreads.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    BmobObject *unread = self.unreads[indexPath.row];
    
    
    cell.textLabel.text = [unread objectForKey:@"title"];
    cell.detailTextLabel.text = [[[unread objectForKey:@"count"] stringValue]stringByAppendingString:@"条未读消息"];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BmobObject *unRead = self.unreads[indexPath.row];
    BmobObject *bObj = [unRead objectForKey:@"source"];
   
    
    TRDetailViewController *vc = [TRDetailViewController new];
    //把bmob对象转成itObj对象
    vc.itObj = [[TRITObject alloc]initWithBmobObject:bObj];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    //删除点击的未读
    [unRead deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"删除成功！");
        }
    }];
    
    
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
