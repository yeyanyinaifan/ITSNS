//
//  TRAnnotation.h
//  ITSNS
//
//  Created by tarena on 16/8/31.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "TRITObject.h"
@interface TRPointAnnotation : BMKPointAnnotation
@property (nonatomic, strong)TRITObject *userInfo;
@end
