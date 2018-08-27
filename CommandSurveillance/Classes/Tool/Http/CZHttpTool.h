//
//  CZHttpTool.h
//
//  Created by apple on 15-3-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//  处理网络的请求

#import <Foundation/Foundation.h>

@interface CZHttpTool : NSObject

/**
 *  发送get请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


/**
 *  发送post请求
 *
 *  @param URLString  请求的基本的url
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)Post:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(id responseObject))success
    failure:(void (^)(NSError *error))failure;


+ (void)accountWithCode:(NSString *)code success:(void (^)(void))success failure:(void (^)(NSError *))failure;

+ (void)getAllDeviceInfoSuccess:(NSString*)strUrl  success:(void (^)(void))success failure:(void (^)(void))failure;


/**
 图片发送

 @param imageFilePath 图片路径
 @param success 发送成功
 @param failure 发送失败
 */
+ (void)sendImageFile:(NSString*)imageFilePath success:(void (^)(NSString* severfileName))success failure:(void (^)(void))failure;
@end
