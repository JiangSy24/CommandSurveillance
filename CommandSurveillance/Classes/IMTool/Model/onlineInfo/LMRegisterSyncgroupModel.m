//
//  LMRegisterSyncgroupModel.m
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/6.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import "LMRegisterSyncgroupModel.h"

@implementation LMRegisterSyncgroupModel
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"member":[LMRegisterSyncgroupModel class]};
}

- (NSString*)name{
    if (_name != nil) {
        _name = [CSStatusTool decodeString:_name];
    }
    return _name;
}

- (NSMutableArray<LMRegisterSyncgroupModel*>*)member{
    if (_member == nil) {
        _member = [NSMutableArray array];
    }
    return _member;
}
@end
