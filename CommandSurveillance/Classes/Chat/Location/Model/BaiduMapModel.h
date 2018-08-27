//
//  BaiduMapModel.h
//  LocationSend
//
//  Created by liangcong on 17/9/20.
//  Copyright © 2017年 Cocav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface BaiduMapModel : NSObject
@property (nonatomic,assign)CLLocationCoordinate2D selectLocation;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *address;
@end
