//
//  AppDelegate.h
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYMainTabbarController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong)LYMainTabbarController *tabbarController;
@property (strong, nonatomic) UIWindow *window;

-(void)showHomeVC;
@end

