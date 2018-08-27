//
//  BaiduMapShowVc.h
//  LocationSend
//
//  Created by liangcong on 17/9/20.
//  Copyright © 2017年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMapModel.h"
@interface BaiduMapShowVc : UIViewController
@property (nonatomic,assign) CGRect imageViewRect;
@property (nonatomic,strong) UIImage *resultImage;
@property (nonatomic,strong) BaiduMapModel *selectModel;
+(instancetype)myTableViewController;
@end
