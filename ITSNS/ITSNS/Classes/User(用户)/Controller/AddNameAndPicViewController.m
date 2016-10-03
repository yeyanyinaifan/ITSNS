//
//  AddNameAndPicViewController.m
//  ITSNS
//
//  Created by tarena on 16/6/25.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import <MBProgressHUD.h>
#import "UIButton+WebCache.h"
#import "AddNameAndPicViewController.h"

@interface AddNameAndPicViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
@property (nonatomic, strong)NSData *imageData;
@end

@implementation AddNameAndPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    
    NSString *nick = [[BmobUser currentUser]objectForKey:@"nick"];
    if (nick.length>0) {
        self.nickTF.text = nick;
    }
   
    NSString *headPath = [[BmobUser currentUser]objectForKey:@"headPath"];
    if (headPath) {
        [self.headBtn sd_setImageWithURL:[NSURL URLWithString:headPath] forState:UIControlStateNormal];
    }
    
    
    
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction{
    
    BmobUser *user = [BmobUser currentUser];
    
    [user setObject:self.nickTF.text forKey:@"nick"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    if (self.imageData) {
        //如果有图片 先上传图片 再保存数据
        
        [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"abc.jpg",@"data":self.imageData}] progressBlock:^(int index, float progress) {
            hud.progress = progress;
            NSLog(@"进度：%d-%f",index,progress);
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            [hud hideAnimated:YES];
            if (isSuccessful) {
                //得到上传完成的图片地址
                BmobFile *file = [array firstObject];
        
                
       
                
                   [user setObject:file.url forKey:@"headPath"];
                
                //更新数据
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                }];
                
            }
            
            
        }];
        
        
    }else{
        
        //更新数据
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        
    }
  
    
    
}
- (IBAction)imageAction:(id)sender {
    
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate =self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.headBtn setImage:image forState:UIControlStateNormal];
    
    
    if ([[info[UIImagePickerControllerReferenceURL] description] hasSuffix:@"PNG"]) {
        self.imageData = UIImagePNGRepresentation(image);
    }else{
        self.imageData = UIImageJPEGRepresentation(image, .5);
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

@end
