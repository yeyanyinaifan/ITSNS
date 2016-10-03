//
//  Utils.m
//  YYText练习
//
//  Created by tarena on 16/8/24.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "amrFileCodec.h"
#import "Utils.h"
#import <AVFoundation/AVFoundation.h>
@implementation Utils
+(NSString *)parseTimeWithTimeStap:(float)timestap{
    
    timestap/=1000;
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timestap];
    
    //获取当前时间对象
    NSDate *nowDate = [NSDate date];
    
    long nowTime = [nowDate timeIntervalSince1970];
    long time = nowTime-timestap;
    if (time<60) {
        return @"刚刚";
    }else if (time<3600){
        return [NSString stringWithFormat:@"%ld分钟前",time/60];
    }else if (time<3600*24){
        return [NSString stringWithFormat:@"%ld小时前",time/3600];
    }else{
        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
    
    
    
    
    
    
    
}


+(void)addScore:(int)score{
    
    BmobUser *user = [BmobUser currentUser];
    
    [user incrementKey:@"Score" byAmount:score];
    
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            NSLog(@"增加积分成功！");
        }
        
        
        
    }];
    
    
    
}
+(void)faceMappingWithText:(YYTextView *)tv{
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    NSMutableDictionary *mapperDic = [NSMutableDictionary dictionary];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"default" ofType:@"plist"];
    NSArray *faceArr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *faceDic in faceArr) {
        
        NSString *imageName = faceDic[@"png"];
        NSString *text = faceDic[@"chs"];
        
        [mapperDic setObject:[UIImage imageNamed:imageName] forKey:text];
        
        
    }
    
    
    parser.emoticonMapper = mapperDic;
    
    tv.textParser = parser;
    
    
    
    
}

+(void)playVoiceWithPath:(NSString *)path{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //得到amr音频数据
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
        //把amr 解码 到wav格式
        data = DecodeAMRToWAVE(data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            player = [[AVAudioPlayer alloc]initWithData:data error:nil];
            [player play];
        });
        
    });
    
    
    
}
+(void)addUnreadWithSource:(TRITObject *)itObj{
    
    //查询是否有评论的记录
    BmobQuery *bq = [BmobQuery queryWithClassName:@"UnRead"];
    [bq whereKey:@"source" equalTo:itObj.bObj];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //如果大于0说明曾经评论过 只需要count+1
        if (array.count>0) {
            
            BmobObject *unReadObj = [array lastObject];
            [unReadObj incrementKey:@"count"];
            
            [unReadObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"未读数量+1成功！");
                }
                
                
            }];
            
            
            
            
        }else{
            
            //创建新的未读
            BmobObject *bObj = [BmobObject objectWithClassName:@"UnRead"];
            
            [bObj setObject:itObj.title forKey:@"title"];
            
            [bObj setObject:itObj.bObj forKey:@"source"];
            
            [bObj setObject:itObj.user forKey:@"toUser"];
            [bObj setObject:@(1) forKey:@"count"];
            
            [bObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"未读添加成功！");
                }
            }];

        }
        
        
    }];
    
    
    
}
@end
