//
//  CSVfilesvr.h
//  CloudSurveillance
//
//  Created by liangcong on 16/12/17.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSVfilesvr : NSObject

@property (nonatomic,assign) int vfilesvrid;//:录像文件服务器ID；

@property (nonatomic,copy) NSString *vfilesvrip;//:录像文件服务器IP；

@property (nonatomic,assign) int vfilesvrport;//:录像文件服务器端口；

@end
