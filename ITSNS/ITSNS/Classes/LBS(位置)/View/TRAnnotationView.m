//
//  TRAnnotationView.m
//  ITSNS
//
//  Created by tarena on 16/8/31.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRAnnotationView.h"
@interface TRAnnotationView()
//@property (nonatomic) UIImageView *iv;
@end
@implementation TRAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
       
//        
        UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 70)];
//        bgIV.userInteractionEnabled = YES;
        bgIV.image = [UIImage imageNamed:@"nearby_map_content"];
        bgIV.transform = CGAffineTransformMakeScale(1.2, 1.2);
//        self.iv = bgIV;
        [self addSubview:bgIV];
        NSLog(@"%@",NSStringFromCGRect(self.bounds));
//
        
        self.headIV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 46, 46)];
        [self addSubview:self.headIV];
        
        self.nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 10, 100, 20)];
        self.nickLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.nickLabel];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 35, 100, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:self.titleLabel];
        self.titleLabel.textColor = self.nickLabel.textColor = LYGreenColor;
        
        //如果不添加大头针点击不到
        self.bounds = bgIV.bounds;
    }
    
    return self;
}

-(void)setItObj:(TRITObject *)itObj{
    _itObj = itObj;
    self.titleLabel.text = itObj.title;
    self.nickLabel.text = [itObj.user objectForKey:@"nick"];
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[itObj.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    
    
    
}






//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//
//}
//在自定义view上添加事件拦截
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    // 当touch point是在_btn上，则hitTest返回_btn
//    CGPoint btnPointInA = [self.iv convertPoint:point fromView:self];
//    if ([self.iv pointInside:btnPointInA withEvent:event])
//    {
//        return self.iv;
//    }
//    // 否则，返回默认处理
//    return [super hitTest:point withEvent:event];
//    
//}

-(void)click
{
    NSLog(@"按钮被点击");
    
}

@end
