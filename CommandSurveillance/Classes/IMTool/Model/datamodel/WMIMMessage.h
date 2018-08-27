//
//  WMIMMessage.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMIMSession.h"

@interface WMIMMessage : NSObject
/**
 *  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号
 */
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,assign) int createdTime;
@property (nonatomic,assign) WMIMConversationType conversationType;
@property (nonatomic,assign) NSString *fromId;
@property (nonatomic,assign) NSString *toId;
@property (nonatomic,copy) NSString *content;//文本就文本，image就是url，是自己的就存本地url,音频就是数据
@property (nonatomic,copy) NSString *videoName;//音频名字
@property (nonatomic,assign) BOOL bIsRead;//是否已读
@property (nonatomic,assign) WMIMSendStatus sendStatus;//发送状态
@property (nonatomic,assign) WMIMessageType msgType;//消息类型
@property (nonatomic,assign) int msgId;
@end
