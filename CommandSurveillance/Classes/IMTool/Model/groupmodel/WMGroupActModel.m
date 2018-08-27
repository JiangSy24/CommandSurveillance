//
//  WMGroupActModel.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/10.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "WMGroupActModel.h"

@implementation WMGroupActModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"joinids":[WMGroupMsgModel class]};
}
@end

@implementation WMGroupMsgModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"member":[WMGroupMsgUserModel class]};
}
@end

@implementation WMGroupMsgUserModel

@end
