//
//  LMRegisterModle.m
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/6.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import "LMRegisterModle.h"

@implementation LMRegisterModle
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"syncuser":[LMRegisterSyncuserModel class],@"syncgroup":[LMRegisterSyncgroupModel class]};
}

+ (instancetype)instance
{
    static dispatch_once_t  onceToken;
    static LMRegisterModle * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[LMRegisterModle alloc] init];
        sSharedInstance.syncuserArry = [NSMutableArray array];
        sSharedInstance.syncgroupArry = [NSMutableArray array];
        sSharedInstance.lmCallArray = [NSMutableArray array];
    });
    return sSharedInstance;
}

- (NSLock*)lock{
    if (_lock == nil) {
        _lock = [NSLock new];
    }
    return _lock;
}
@end

@implementation LMRegisterChatModel
@end
