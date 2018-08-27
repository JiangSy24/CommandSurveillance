//
//  WMIMMessageDefaul.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#ifndef WMIMMessageDefaul_h
#define WMIMMessageDefaul_h

#define NoticLoginReflash      @"GlobalUpLoadNotificationTem"   // 上下线人员组变化通知
// 会话类型
typedef NS_ENUM(int,WMIMConversationType) {
    WMIMConversationTypeSingle = 1,    //单聊
    WMIMConversationTypeGroup  = 2,        //群聊
};
typedef NS_ENUM(int,WMIMSendStatus){
    WMIMSendStatus_SENDING = 0,   //发送中
    WMIMSendStatus_FAILED,        //发送失败
    WMIMSendStatus_SENT           //发送成功
};

/**
 *  消息内容类型枚举
 */
typedef NS_ENUM(NSInteger, WMIMessageType){
    /**
     *  文本类型消息
     */
    WMIMessageTypeText          = 0,
    /**
     *  声音类型消息
     */
    WMIMessageTypeAudio         = 1,
    /**
     *  图片类型消息
     */
    WMIMessageTypeImage         = 2,
    /**
     *  视频类型消息
     */
    WMIMessageTypeVideo         = 3,
    /**
     *  位置类型消息
     */
    WMIMessageTypeLocation      = 4,
};

/*
 int WM_IM_MsgType_Invalid = -1;
 int WM_IM_MsgType_Text = 0;
 int WM_IM_MsgType_Voice = 1;
 int WM_IM_MsgType_Pic = 2;
 int WM_IM_MsgType_Video = 3;
 int WM_IM_MsgType_Location = 4;
 int WM_IM_MsgType_SharingMsg = 5;
 int WM_IM_MsgType_RefurbishLocation = 6;
 */
#endif /* WMIMMessageDefaul_h */
