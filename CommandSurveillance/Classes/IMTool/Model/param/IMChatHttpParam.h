//
//  IMChatHttpParam.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/1.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 http://ip:port/?msgid=257&userid=1&dstuserid=2&type=0&seq=4556&content=wedf&resend=0
 ip:服务器IP地址；
 port:服务器端口号；
 msgid:消息ID，参见HttpMsgId定义；
 userid:用户ID;
 dstuserid:目的用户ID;
 seq：消息序，用于发送失败重新发送时，判断消息否非为同一个，可以填写发送端的时间（失败重新发送和第一次发送的值必须一样）；
 resend:是否为失败重新发送：0-否，1-是；
 type:消息类型：0-文本，1-语言，2-图片，3-视频，4-位置；
 content：消息内容：文本-文本的聊天消息，语言-语音数据，图片-图片的url地址，视频-视频url地址，位置-位置内容，大小不超过2K；
 
 回复：
 { "result" : 0，"chatmsgid" : 1}
 result：结果值(0-成功，1-失败，其他-错误码);
 chatmsgid:聊天消息id;
 
 */
@interface IMChatHttpParam : NSObject
@property (nonatomic,assign) int msgid;//消息ID，参见HttpMsgId定义；
@property (nonatomic,assign) int userid;//用户ID;
@property (nonatomic,assign) int dstuserid;//目的用户ID;
@property (nonatomic,assign) int seq;//：消息序，用于发送失败重新发送时，判断消息否非为同一个，可以填写发送端的时间（失败重新发送和第一次发送的值必须一样）；
@property (nonatomic,assign) int resend;//:是否为失败重新发送：0-否，1-是；
@property (nonatomic,assign) int type;//:消息类型：0-文本，1-语言，2-图片，3-视频，4-位置；
@property (nonatomic,copy) NSString* content;//：消息内容：文本-文本的聊天消息，语言-语音数据，图片-图片的url地址，视频-视频url地址，位置-位置内容，大小不超过2K；
@end

@interface IMChatHttpModel : NSObject
@property (nonatomic,assign) int  result;//：结果值(0-成功，1-失败，其他-错误码);
@property (nonatomic,assign) int  chatmsgid;//:聊天消息id;
@end
