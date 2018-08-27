//
//  CSAccountTool.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSAccountTool : NSObject

+ (void)sendMessageGetScode:(NSString*)phoneNum;

+ (void)sendMessageGetScode:(NSString*)phoneNum url:(NSString*)strUrl success:(void (^)(CSAccount* account))getAccount;

+ (NSString*) getErrMsgFromResult:(int)result;

+ (void)skipToMainTabBarController;

+ (void)saveAccount:(CSAccount *)account;

+ (CSAccount *)account;

+ (void)deleteAccountFile;

+ (void)deleteUserInfo;

/**
 *  保存用户信息
 */
+ (void)saveUserInfo:(CSUserInfo *)userInfo;

/**
 *  提取用户信息
 */
+ (CSUserInfo *)userInfo;

+(BOOL) isConnectionAvailable;

+ (NSData *)zipImageWithImage:(UIImage *)image;
@end
