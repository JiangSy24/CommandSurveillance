//
//  CSIPPortStringModel.m
//  CloudSurveillance
//
//  Created by liangcong on 17/6/9.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import "CSIPPortStringModel.h"

@interface CSIPPortStringModel()

@end

@implementation CSIPPortStringModel
MJCodingImplementation
+ (void)saveIpList:(CSIPPortStringModel *)list
{
    BOOL bIs = [NSKeyedArchiver archiveRootObject:list toFile:CZIPListFile];
}

+ (CSIPPortStringModel *)list
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:CZIPListFile];
}

- (BOOL)insert:(NSString*)ip port:(int)port{
    BOOL bStatus = NO;
    for (NSString *model in self.strIpPort) {
        if ([model isEqualToString:[NSString stringWithFormat:@"%@:%d",ip,port]]) {
            [self.strIpPort removeObject:model];
            break;
        }
    }
    
    if (!bStatus) {
        [self.strIpPort insertObject:[NSString stringWithFormat:@"%@:%d",ip,port] atIndex:0];
    }
    return bStatus;
}

- (NSMutableArray<NSString*>*)strIpPort{
    if (_strIpPort == nil) {
        _strIpPort = [NSMutableArray array];
    }
    return _strIpPort;
}
@end
