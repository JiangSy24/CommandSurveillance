//
//  CSMapShowVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/16.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMapShowVController.h"
#import <MAMapKit/MAMapKit.h>

@interface CSMapShowVController ()<MAMapViewDelegate>{
    MAMapView *_mapView;
    // 第一次定位标记
    BOOL isFirstLocated;
}
//洗装备，气盾抗性百分比耐力身法僵直，内功会心，内功攻击。
//百炼防具
@end

@implementation CSMapShowVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0,0, CSScreenW, CSScreenH)];
    _mapView.delegate = self;
    // 不显示罗盘
    _mapView.showsCompass = NO;
    // 不显示比例尺
    _mapView.showsScale = NO;
    // 地图缩放等级
    _mapView.zoomLevel = 16;
    // 开启定位
    _mapView.showsUserLocation = YES;

    [self.view addSubview:_mapView];
    
    CGFloat flongitude = 0;
    CGFloat flatitude = 0;
    NSArray<NSString*> *array = [self.message.mediaPath componentsSeparatedByString:@"-"];
    if (array.count > 3) {
        flongitude = [array[0] floatValue];
        flatitude = [array[1] floatValue];
    }
    //    [NSString stringWithFormat:@"%f-%f-%@-%@",model.longitude,model.latitude,model.address,[imageData base64EncodedStringWithOptions:0]];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(flatitude,flongitude);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [_mapView addAnnotation:pointAnnotation];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(flatitude,flongitude)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStyleDone target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.title = array[2];
}

- (void)goback{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    // 首次定位
    if (updatingLocation && !isFirstLocated) {

        isFirstLocated = YES;

    }
}
@end
