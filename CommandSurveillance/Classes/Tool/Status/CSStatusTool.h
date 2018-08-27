//
//  CSStatusTool.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/20.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMIMMessage.h"
#import "LMRegisterSyncgroupModel.h"

@interface CSStatusTool : NSObject

+ (NSString *)_859ToUTF8:(NSString *)oldStr;

+ (NSString *)transform:(NSString *)chinese;

+ (NSString*)encodeString:(NSString*)unencodedString;

+ (NSString *)decodeString:(NSString*)encodedString;

+ (UIColor*)getTextColor:(NSInteger)iResultId; // 获取问题处理状态颜色

+ (NSString*)getProblemResult:(NSInteger)iResultId; // 获取问题描述

+ (NSString*)getTimeFormat:(int)timeValue;  // 2016-09-09

+ (NSString*)getWMEventType:(NSInteger)iResultId;

+ (NSString*)getErrorStrInfo:(int)iError;

+ (NSString*)getShowUserName:(NSString*)fromStr;

+ (NSString*)getShowUserName:(NSString *)fromStr charNum:(int)iNum;

+ (NSString*)contentMake:(WMIMMessage*)msg;

+ (NSString*)pathMake:(WMIMMessage*)msg;

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date;

+ (NSDateComponents *)dateComponentsFromSince1970:(int)itime;

+ (void)skipOneChatVc:(WMIMSession*)sessionTem userId:(int)id vController:(UIViewController*)vc;

+ (void)skipGroupChatVc:(LMRegisterSyncgroupModel*)model vController:(UIViewController*)vc;
@end
