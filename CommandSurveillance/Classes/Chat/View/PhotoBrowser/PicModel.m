//
//  PicModel.m
//  ZLPhotoBrowser
//
//  Created by liangcong on 17/4/14.
//  Copyright © 2017年 long. All rights reserved.
//

#import "PicModel.h"

@implementation PicModel

+ (instancetype)instance
{
    static dispatch_once_t  onceToken;
    static PicModel * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PicModel alloc] init];
    });
    return sSharedInstance;
}

@end
