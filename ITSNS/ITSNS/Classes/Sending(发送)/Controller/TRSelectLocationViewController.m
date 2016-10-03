//
//  TRSelectLocationViewController.m
//  ITSNS
//
//  Created by tarena on 16/8/25.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRAnnotation.h"
#import <MapKit/MapKit.h>
#import "TRSelectLocationViewController.h"

@interface TRSelectLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TRSelectLocationViewController
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    //删除所有大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    
    CGPoint p = [sender locationInView:self.view];
    
    CLLocationCoordinate2D coord = [self.mapView convertPoint:p toCoordinateFromView:self.mapView];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setFloat:coord.longitude forKey:@"lon"];
    [ud setFloat:coord.latitude forKey:@"lat"];
    [ud synchronize];
    
    TRAnnotation *ann = [[TRAnnotation alloc]init];
    ann.coordinate = coord;
    [self.mapView addAnnotation:ann];
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择位置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
}

- (void)doneAction {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
