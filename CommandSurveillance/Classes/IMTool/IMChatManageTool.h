//
//  IMChatManageTool.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/29.
//  Copyright © 2018年 liangcong. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "IMChatMangeProtocol.h"
#import "IMTeamManagerProtocol.h"

@interface IMChatManageTool : NSObject
/**
     获取实例

     @return 实例
 */
+ (instancetype)instance;

/**
     聊天登录，里面有断线重连功能，外部调用一次即可。

     @param strUserName 登录用户名
     @param strPassword 密码
     @param address 服务器地址
     @param port 服务器端口
     @param success 成功回调
     @param failure 失败回调
 */
- (void)chatLoginUserName:(NSString*)strUserName passWord:(NSString*)strPassword ipAddress:(NSString*)address port:(int)port success:(void (^)(Authenticate* model))success failure:(void (^)(int error))failure;

/**
    聊天类
 */
@property (nonatomic,strong,readonly) id<WMIMChatManageTool> chatManager;

/**
    本地消息类
 */
@property (nonatomic,strong,readonly) id<WMIMChatMsgData> msgDataManage;

/**
    语音类
 */
@property (nonatomic,strong,readonly) id<WMIMChatCallManage> callManage;

/*
    群组管理类
 */
@property (nonatomic,strong,readonly) id<WMIMTeamManageTool> teamManage;
@end

