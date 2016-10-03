//
//  TRAnnotationView.h
//  ITSNS
//
//  Created by tarena on 16/8/31.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "TRITObject.h"
@interface TRAnnotationView : BMKAnnotationView
@property (nonatomic, strong)UILabel *nickLabel;
@property (nonatomic, strong)UIImageView *headIV;
@property (nonatomic, strong)UILabel *titleLabel;

@property (nonatomic, strong)TRITObject *itObj;
@end
