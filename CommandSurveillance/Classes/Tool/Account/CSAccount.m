//
//  CSAccount.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSAccount.h"

@implementation CSAccount

MJCodingImplementation
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    CSAccount *account = [[self alloc] init];
    
    [account setValuesForKeysWithDictionary:dict];
    
    return account;
}


@end
