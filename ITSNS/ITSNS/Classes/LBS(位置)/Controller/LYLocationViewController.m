//
//  LYLocationViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRDetailViewController.h"
#import "TRPointAnnotation.h"
#import "TRAnnotationView.h"
#import "TRITObject.h"
#import "LYLocationViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
@interface LYLocationViewController ()<BMKMapViewDelegate>
@property (nonatomic, strong)BMKMapView* mapView;
@property (nonatomic, strong)TRPointAnnotation *selectedAnn;
@end

@implementation LYLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    self.mapView = mapView;
    
    //让地图显示到上次发消息的位置
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    float lon = [ud floatForKey:@"lon"];
    float lat = [ud floatForKey:@"lat"];
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(lat, lon);
    //设置地图缩放级别
    [_mapView setZoomLevel:14];
}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    

    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //删除之前的圆形
    [_mapView removeOverlays:_mapView.overlays];
    
    //添加圆形
    BMKCircle *circle = [BMKCircle circleWithCenterCoordinate:mapView.centerCoordinate radius:5000];
 
    [_mapView addOverlay:circle];
    
    
    
    
    //发出请求 获取某个位置周边的问题消息或项目
    BmobQuery *query = [BmobQuery queryWithClassName:@"ITObject"];
    //得到地图中心点位置
    BmobGeoPoint *point = [[BmobGeoPoint alloc]initWithLongitude:mapView.centerCoordinate.longitude WithLatitude:mapView.centerCoordinate.latitude];
    [query includeKey:@"user"];
    [query whereKey:@"location" nearGeoPoint:point withinKilometers:5];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        for (BmobObject *bObj in array) {
            
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            //判断是否有位置
            if (itObj.location) {
                
               TRPointAnnotation *pointAnnotation = [[TRPointAnnotation alloc]init];
                
                pointAnnotation.userInfo = itObj;
                
                CLLocationCoordinate2D coor;
                coor.latitude = itObj.location.latitude;
                coor.longitude = itObj.location.longitude;
                pointAnnotation.coordinate = coor;
                pointAnnotation.title = [itObj.user objectForKey:@"nick"];
                pointAnnotation.subtitle = itObj.title;
                
                [self.mapView addAnnotation:pointAnnotation];
            }
            
            
        }
        
    }];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{

    TRAnnotationView *annView = (TRAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ann"];
    if (!annView) {
        annView = [[TRAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ann"];
    }
    
    annView.userInteractionEnabled = YES;
    
    TRPointAnnotation *ann = (TRPointAnnotation *)annotation;
    annView.itObj = ann.userInfo;
    
    
    
    
    return annView;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //取消选中
    [self.mapView deselectAnnotation:self.selectedAnn animated:YES];
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    TRPointAnnotation *ann = (TRPointAnnotation *)view.annotation;
    self.selectedAnn = ann;
    NSLog(@"点击到了");
    TRITObject *itObj = ann.userInfo;
    
    
    TRDetailViewController *vc = [TRDetailViewController new];
    vc.itObj = itObj;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor alloc] initWithRed:1 green:0 blue:0 alpha:0.5];
        circleView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.5];
        circleView.lineWidth = 1.0;
        
        return circleView;
}


@end
