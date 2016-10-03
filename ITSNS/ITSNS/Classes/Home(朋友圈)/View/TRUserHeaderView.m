//
//  TRUserHeaderView.m
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRChattingViewController.h"
#import "TRUserHeaderView.h"
#import "RNBlurModalView.h"
#import "XHDrawerController.h"
@implementation TRUserHeaderView

-(void)awakeFromNib{
    
    self.headIV.layer.cornerRadius = 10;
    
    self.headIV.layer.masksToBounds = YES;
    
}
-(void)setUser:(BmobUser *)user{
    _user = user;
    
    //显示积分
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ 分",[user objectForKey:@"Score"]];
    
    
    self.nickTF.text = [user objectForKey:@"nick"];
    

    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
   
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //把下载下来的图片模糊 并显示
        self.bgIV.image = [image boxblurImageWithBlur:.5];
        
    }];
    
}

-(void)updateSubViewsWithOffset:(float)offset{
    
    offset+=64;
    
    
    NSLog(@"%f",offset);
    //让背景图片缩放
    if (offset<0&&offset>=-180) {
//        0    1
//        200  1.5
        float scale = 1+ -offset/400;
//        1 + offset/200
        
        self.bgIV.transform = CGAffineTransformMakeScale(scale, scale);
        
        
        
    }
    
    
    //让label隐藏
    if (offset>0&&offset<=100) {
//        0    100
//        1     0
        
        
        self.labelView.alpha =  1 - offset/100;
        
       
        
    }
    
    
    if (offset>0&&offset<=114) {
        [self bringSubviewToFront:self.headIV];
        float scale = 1 - offset/250;
        
        self.headIV.transform = CGAffineTransformMakeScale(scale, scale);
        NSLog(@"====%f",self.headIV.center.y);
    }
    
    if (offset>114&&offset<185) {
        
        [self bringSubviewToFront:self.bottomView];
        
        
        float y = offset - 114;
        
        self.headIV.center = CGPointMake(self.headIV.center.x, 154+y);
        
        
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)clicked:(UIButton *)sender {
    
    if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"聊天"]) {
        
        //跳转到聊天页面
        TRChattingViewController *vc = [TRChattingViewController new];
        vc.toUsername = self.user.username;
        vc.toUser = self.user;
        //得到当前的导航控制器
        XHDrawerController *dc =  (XHDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UITabBarController *tc = (UITabBarController *)dc.centerViewController;
        UINavigationController *nc = tc.selectedViewController;
        
        [nc pushViewController:vc animated:YES];
        
        
    }else{
    
    NSString *m = [NSString stringWithFormat:@"是否添加%@为好友？",[self.user objectForKey:@"nick"]];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:m preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[EasemobManager shareManager]addFriendWithName:self.user.username];

    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action1];
    [ac addAction:action2];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    }
}
@end
