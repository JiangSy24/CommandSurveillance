//
//  CSCreateGroupVc.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCreateGroupVc : UIViewController
+(instancetype)myTableViewController;
@property (nonatomic,strong) NSMutableArray<CSOneUserModel*> *array;
@end
