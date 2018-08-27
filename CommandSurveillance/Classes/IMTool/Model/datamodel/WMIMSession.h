//
//  WMIMSession.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMIMMessageDefaul.h"
#import "IMSdk_i.h"

@interface WMGroupMember : NSObject
@property (nonatomic,assign) int id;
@property (nonatomic,copy) NSString *name;

//外用
@property (nonatomic, assign) BOOL bIsJoinSession;//是否加入了会议
@property (nonatomic, assign) BOOL bIsOnMic;//是否在麦说话
@end

@class WMIMMessage;
@interface WMIMSession : NSObject
/**
 *  会话ID,如果当前session为team,则sessionId为teamId(imsdk创建组成功会给的id),如果是P2P则为对方帐号
 */
@property (nonatomic,copy) NSString *sessionId;
@property (nonatomic,assign) int createdTime;
@property (nonatomic,assign) WMIMConversationType conversationType;
@property (nonatomic,assign) BOOL bisTop;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSMutableArray<WMGroupMember *>* member;   // 会话人员，如果是单聊只放那个人的
@property (nonatomic,strong) WMIMMessage *message;      //  最后一条数据
@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,assign) int owenid;//群主id

@property (nonatomic,assign) int iunReadCount;

@property (nonatomic,assign) WM_IM_CallType callType;   //呼叫类型
/**
 *  通过id和type构造会话对象
 *
 *  @param createdTime   创建时间
 *  @param sessionType 会话类型
 *  @param toId 为组的话填0
 *  @return 会话对象实例
 */
//+ (instancetype)session:(int)createdTime
//                   type:(WMIMConversationType)sessionType
//                   toId:(int)toId;

@end
