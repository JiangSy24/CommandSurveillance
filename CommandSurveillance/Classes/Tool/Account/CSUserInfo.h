//
//  CSUserInfo.h
//  CloudSurveillance
//
//  Created by liangcong on 16/9/7.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  这个类主要用于记住用户信息，登录名，密码，头像，电话号码
 */
@interface CSUserInfo : NSObject

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  电话号
 */
@property (nonatomic, copy) NSString *phoneNum;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

/**
 *  头像
 */
@property (nonatomic, strong) UIImage *userImage;

@end
