//
//  LMCallModel.m
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/7.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import "LMCallModel.h"

@implementation LMCallModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"users":[LMUserIdModel class]};
}
@end
