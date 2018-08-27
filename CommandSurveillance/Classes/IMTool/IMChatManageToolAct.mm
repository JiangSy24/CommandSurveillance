//
//  IMChatManageToolAct.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "IMChatManageToolAct.h"
#import "IMChatHttpParam.h"
#import "IMSdk.h"
#import "NSMutableArray+WeakReferences.h"

#define kNewMessagesNotifacation @"NewMessagesNotifacation"
@interface IMChatManageToolAct()
@property (nonatomic,strong) NSMutableArray<id<WMIMChatManageToolDelegate>> *delegateArray;
@end

@implementation IMChatManageToolAct

/*
 //聊天消息ID
 enum enmChatMsgTypeId
 {
 WM_IM_ChatMsgTypeId_Invalid = 0,
 WM_IM_ChatMsgTypeId_Single,  //单人聊天消息{"content" : "456", "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
 WM_IM_ChatMsgTypeId_Group,  //群组聊天消息 {"content" : "456", "groupid" : 39, "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
 };
 */

//聊天消息回调
/*
 * nMsgTypeId:聊天消息类型id
 * nChatMsgId:聊天消息id(同种消息类型的唯一标识)
 * pMsgData:聊天消息内容
 */
void WMChatMsgCallBack(int32_t nMsgTypeId, int32_t nChatMsgId, const char* pMsgData, int32_t nDataLen, void* pUser){
    NSString *tem =[NSString stringWithUTF8String:pMsgData];
    NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"WMChatMsgCallBack: %@",stringData);
    LMRegisterChatModel *model = [LMRegisterChatModel mj_objectWithKeyValues:stringData];
    WMIMConversationType temT;
    NSString *strDbName = nil;
    switch (nMsgTypeId) {
        case WM_IM_ChatMsgTypeId_Single:
        {
            temT = WMIMConversationTypeSingle;
            strDbName = UserDbName(model.srcuserId);
            break;
        }
        case WM_IM_ChatMsgTypeId_Group:
        {
            temT = WMIMConversationTypeGroup;
            strDbName = TableDbName(model.groupid);
            break;
        }
        default:
            break;
    }
    
    //保存数据库
    WMIMMessage *msg = [[WMIMMessage alloc] init];
    msg.sessionId = UserDicKey(model.srcuserId);
    msg.bg_tableName = strDbName;
    msg.conversationType = temT;
    msg.fromId = UserDicKey(model.srcuserId);
    msg.toId = UserDicKey([CSUrlString instance].account.sysconf.accountid);
    msg.bIsRead = NO;
    msg.msgType = (WMIMessageType)model.type;
    msg.msgId = nChatMsgId;
    
    switch (msg.msgType) {
        case WMIMessageTypeText:
        {
            msg.content = [CSStatusTool decodeString:model.content];
            break;
        }
        case WMIMessageTypeAudio:
        {
            NSString *toPath = [NSString stringWithFormat:@"%@/%d.amr",RecordPath,msg.msgId];
            NSString *strDecode = [CSStatusTool decodeString:model.content];
            if (strDecode != nil) {
                NSData *decodedImageData   = [[NSData alloc] initWithBase64EncodedString:strDecode options:NSDataBase64DecodingIgnoreUnknownCharacters];
                
                BOOL bIsOk = [decodedImageData writeToFile:toPath atomically:NO];
                
                if (bIsOk) {
                    
                }
                
                
            }
            msg.videoName = [NSString stringWithFormat:@"%d.amr",msg.msgId];
            break;
        }
        case WMIMessageTypeImage:
        {
            msg.content = model.content;
            break;
        }
        default:
            break;
    }
    
    msg.createdTime = [NSDate date].timeIntervalSince1970;//发送时间没有用，按系统给的来
    [msg bg_save];
    // 发通知吧
    [[NSNotificationCenter defaultCenter] postNotificationName:kNewMessagesNotifacation object:msg];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:kNewMessagesNotifacation object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray<id<WMIMChatManageToolDelegate>>*)delegateArray{
    if (_delegateArray == nil) {
        _delegateArray = [NSMutableArray mutableArrayUsingWeakReferences];
    }
    return _delegateArray;
}

- (void)sendUserMessage:(WMIMMessage*)msg{

    // 文件服务器上传
    if (msg.msgType == WMIMessageTypeImage) {
        [CZHttpTool sendImageFile:msg.content success:^(NSString *strFileName) {
            [self sendSingle:msg fileName:strFileName];
        } failure:^{
            
        }];
    }else{
        [self sendSingle:msg fileName:nil];
    }
    
    
}

- (void)sendSingle:(WMIMMessage*)msg fileName:(NSString*)strFileName{
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
    NSString *content = (strFileName==nil) ? [self dealWithInfo:msg] : strFileName;
    msg.bg_tableName = UserDbName(msg.sessionId.intValue);
    NSString *str = [NSString stringWithFormat:@"msgid=257&userid=%d&dstuserid=%d&seq=%d&resend=0&type=%d&content=%@",[CSUrlString instance].account.sysconf.accountid,msg.toId.intValue,(int)[NSDate date].timeIntervalSince1970,(int)msg.msgType,content];
    
    msg.bIsRead = YES;
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[CSUrlString instance].account.chatAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 3.f;
    
    //5.设置请求体
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (nil != data) {
            //8.解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"sendMessage %@",dict);
            
            IMChatHttpModel *model = [IMChatHttpModel mj_objectWithKeyValues:dict];
            if (model.result == 0) {
                msg.sendStatus = WMIMSendStatus_SENT;
                msg.msgId = model.chatmsgid;
                [msg bg_save];
                [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                    if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                        [tem sendMessage:msg didCompleteWithError:nil];
                    }
                }];
            }else{
                msg.sendStatus = WMIMSendStatus_FAILED;
                [msg bg_save];
                [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                    if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                        [tem sendMessage:msg didCompleteWithError:nil];
                    }
                }];
            }
        }else{
            msg.sendStatus = WMIMSendStatus_FAILED;
            [msg bg_save];
            [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                    [tem sendMessage:msg didCompleteWithError:nil];
                }
            }];
        }
        
    }];
    
    // 启动任务
    [dataTask resume];
}

- (void)sendGroupMessage:(WMIMMessage *)msg{
    /*
     协议说明：
     向即时通讯服务器发送群组聊天消息
     请求：
     http://ip:port/?msgid=258&userid=1&groupid=2&type=0&seq=4556&content=wedf&resend=0
     ip:服务器IP地址；
     port:服务器端口号；
     msgid:消息ID，参见HttpMsgId定义；
     userid:用户ID;
     groupid:目的组ID;
     seq：消息序，用于发送失败重新发送时，判断消息否非为同一个，可以填写发送端的时间（失败重新发送和第一次发送的值必须一样）；
     resend:是否为失败重新发送：0-否，1-是；
     type:消息类型：0-文本，1-语言，2-图片，3-视频，4-位置；
     content：消息内容：文本-文本的聊天消息，语言-语音数据，图片-urlcode(图片的url地址-/缩略图内容的base64编码)，视频-(视频url地址-/缩略图内容的URLENCODE编码)，位置-位置内容，大小不超过30K；
     
     回复：
     { "result" : 0，"chatmsgid" : 1}
     result：结果值(0-成功，1-失败，其他-错误码);
     chatmsgid:聊天消息id;
     
     */
    msg.bg_tableName = TableDbName(msg.sessionId.intValue);
    NSString *str = [NSString stringWithFormat:@"msgid=258&userid=%d&groupid=%d&seq=%d&resend=0&type=%d&content=%@",[CSUrlString instance].account.sysconf.accountid,msg.toId.intValue,(int)[NSDate date].timeIntervalSince1970,(int)msg.msgType,[self dealWithInfo:msg]];
    
    msg.bIsRead = YES;
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURL *url = [NSURL URLWithString:[CSUrlString instance].account.chatAddress];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //4.修改请求方法为POST
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 3.f;
    
    //5.设置请求体
    request.HTTPBody = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (nil != data) {
            //8.解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"sendMessage %@",dict);
            
            IMChatHttpModel *model = [IMChatHttpModel mj_objectWithKeyValues:dict];
            if (model.result == 0) {
                msg.sendStatus = WMIMSendStatus_SENT;
                msg.msgId = model.chatmsgid;
                [msg bg_save];
                [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                    if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                        [tem sendMessage:msg didCompleteWithError:nil];
                    }
                }];
            }else{
                msg.sendStatus = WMIMSendStatus_FAILED;
                [msg bg_save];
                [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                    if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                        [tem sendMessage:msg didCompleteWithError:nil];
                    }
                }];
            }
        }else{
            msg.sendStatus = WMIMSendStatus_FAILED;
            [msg bg_save];
            [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(sendMessage:didCompleteWithError:)]) {
                    [tem sendMessage:msg didCompleteWithError:nil];
                }
            }];
        }
        
    }];
    
    // 启动任务
    [dataTask resume];
    
}

- (void)sendMessage:(WMIMMessage* _Nonnull)msg{
    if (msg.conversationType == WMIMConversationTypeSingle) {
        [self sendUserMessage:msg];
    }else{
        [self sendGroupMessage:msg];
    }
}

-(void)receiveMessage:(NSNotification *)noti{
    WMIMMessage *message = noti.object;
    if (message.msgType == WMIMessageTypeImage) {
        NSString *strContent = [NSString stringWithFormat:@"http://%@:%d/%@/%@",[CSUrlString instance].account.sysconf.vfilesvrip,[CSUrlString instance].account.sysconf.vfilesvrdownport,message.fromId,message.content.lastPathComponent];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strContent]];

        NSString *path = [NSString stringWithFormat:@"%@/%@", PicPath, message.content.lastPathComponent];//Documents,Library,tmp
        BOOL result = [imageData writeToFile:path atomically:YES];
        if (!result) {
            // 写入临时文件失败
            
        }

    }
    // 数据库存在就不存
    [self emFun:^(id<WMIMChatManageToolDelegate> tem) {
        if (tem && [tem respondsToSelector:@selector(recvMessage:)]) {
            [tem recvMessage:message];
        }
    }];
    
}

- (void)emFun:(void (^)(id<WMIMChatManageToolDelegate> tem))actFun{
    for (id<WMIMChatManageToolDelegate> tem in self.delegateArray) {
        if (actFun) {
            actFun(tem);
        }
    }
}

- (NSString*)dealWithInfo:(WMIMMessage*)msg{
    NSString *strType = nil;
    switch (msg.msgType) {
        case WMIMessageTypeText:
        {
            strType = [CSStatusTool encodeString:msg.content];
            break;
        }
        case WMIMessageTypeAudio:
        {
            strType = [CSStatusTool encodeString:msg.content];
            break;
        }
        case WMIMessageTypeImage:
        {
            break;
        }
        case WMIMessageTypeLocation:
        {
            break;
        }
        default:
            break;
    }
    return strType;
}

/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)addDelegate:(id<WMIMChatManageToolDelegate>_Nonnull)delegate{
    [self.delegateArray addObject:delegate];
}

/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)removeDelegate:(nullable id<WMIMChatManageToolDelegate>)delegate{
    for (id<WMIMChatManageToolDelegate> tem in self.delegateArray) {
        if ([tem isEqual:delegate]) {
            [self.delegateArray removeObject:tem];
            break;
        }
    }
}

@end
