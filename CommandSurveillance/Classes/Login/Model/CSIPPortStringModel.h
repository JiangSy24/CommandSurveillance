//
//  CSIPPortStringModel.h
//  CloudSurveillance
//
//  Created by liangcong on 17/6/9.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSIPPortStringModel : NSObject
+ (void)saveIpList:(CSIPPortStringModel *)list;
+ (CSIPPortStringModel *)list;
- (BOOL)insert:(NSString*)ip port:(int)port;
/**
 *  数组存放历史，第一个为默认 格式 ip : port
 */
@property (nonatomic,strong) NSMutableArray<NSString*>* strIpPort;
@end
