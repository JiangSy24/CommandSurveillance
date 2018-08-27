//
//  CSStatusTool.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/20.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSStatusTool.h"
#import "DAYUtils.h"
//#import "PlatformSdk_i.h"
#import "WMAuthenticateSdk_i.h"

@implementation CSStatusTool

+ (NSString *)_859ToUTF8:(NSString *)oldStr
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);

    NSString *str = nil;
    if ([oldStr canBeConvertedToEncoding:kCFStringEncodingISOLatin1]) {
        str = [NSString stringWithUTF8String:[oldStr cStringUsingEncoding:enc]];
    }else{
        str = oldStr;
    }
    
    return str;
}

// 汉字转拼音
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

//URLEncode
+(NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

//URLDEcode
+(NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)encodedString, CFSTR(""), kCFStringEncodingUTF8);
    return decodedString;
}

+ (NSString*)getTimeFormat:(int)timeValue{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeValue];
    NSDateComponents *selectComps = [DAYUtils dateComponentsFromDate:date];
    
    return [NSString stringWithFormat:@"%ld-%02ld-%02ld",selectComps.year,selectComps.month,selectComps.day];
}

+ (NSString*)getWMEventType:(NSInteger)iResultId{
    NSString *str = nil;
//    switch (iResultId) {
//        case WMEventType_VIDEO_LOST:
//            str = @"视频(信号)丢失";
//            break;
//        case WMEventType_EXTERNAL:
//            str = @"外部(信号量)报警";
//            break;
//        case WMEventType_VIDEO_COVERED:
//            str = @"视频遮盖";
//            break;
//        case WMEventType_MOTION:
//            str = @"移动侦测";
//            break;
//        case WMEventType_DISARM:
//            str = @"布撤防报警";
//            break;
//        case WMEventType_FACE_DETECTION:
//            str = @"人脸侦测";
//            break;
//        case WMEventType_ENTER_AREA:
//            str = @"目标进入区域";
//            break;
//        case WMEventType_LEAVE_AREA:
//            str = @"目标离开区域";
//            break;
//        case WMEventType_INTRUSION:
//            str = @"周界入侵（区域入侵）";
//            break;
//        case WMEventType_LEFT:
//            str = @"物品遗留";
//            break;
//        case WMEventType_TAKE:
//            str = @"物品拿取";
//            break;
//        default:
//            break;
//    }
    return str;
}

+ (NSString*)getErrorStrInfo:(int)iError{
    NSString *str = [NSString string];
    switch (iError) {
        case WM_Authenticate_ErrorCode_Fail:
        {
            str = @"未知错误";
            break;
        }
        case WM_Authenticate_ErrorCode_WaitResult:
        {
            str = @"异步等待结果";
            break;
        }
        case WM_Authenticate_ErrorCode_InvalidParameter:
        {
            str = @"无效参数";
            break;
        }
        case WM_Authenticate_ErrorCode_SdkInitFail:
        {
            str = @"Sdk初始化失败";
            break;
        }
        case WM_Authenticate_ErrorCode_HasInit:
        {
            str = @"Sdk已经初始化";
            break;
        }
        case WM_Authenticate_ErrorCode_NoInit:
        {
            str = @"Sdk未初始化";
            break;
        }
        case WM_Authenticate_ErrorCode_ConnectFail:
        {
            str = @"连接失败";
            break;
        }
        case WM_Authenticate_ErrorCode_ResponseTimeout:
        {
            str = @"超时";
            break;
        }
        case WM_Authenticate_ErrorCode_HasLogin:
        {
            str = @"已经登录";
            break;
        }
        case WM_Authenticate_ErrorCode_NoLogin:
        {
            str = @"没有登录";
            break;
        }
        case WM_Authenticate_ErrorCode_NoExistUserName:
        {
            str = @"用户名不存在";
            break;
        }
        case WM_Authenticate_ErrorCode_ErrorPassword:
        {
            str = @"密码错误";
            break;
        }
        case WM_Authenticate_ErrorCode_ServerReject:
        {
            str = @"服务器拒绝";
            break;
        }
        default:
            break;
    }
    
    return str;
}

+ (NSString*)getShowUserName:(NSString *)fromStr{
    NSRange range;
    range.location = fromStr.length > 2 ? fromStr.length - 2 : 0;
    range.length = fromStr.length > 2 ? 2 : fromStr.length;
    return [fromStr substringWithRange:range];
}

+ (NSString*)getShowUserName:(NSString *)fromStr charNum:(int)iNum{
    NSRange range;
    range.location = fromStr.length > iNum ? fromStr.length - iNum : 0;
    range.length = fromStr.length > iNum ? iNum : fromStr.length;
    return [fromStr substringWithRange:range];
}

+ (NSString*)contentMake:(WMIMMessage*)msg{
    NSString *strContent = nil;
    switch (msg.msgType) {
        case WMIMessageTypeText:
            strContent = msg.content;
            break;
        case WMIMessageTypeAudio:
            strContent = @"[语音]";
            break;
        case WMIMessageTypeImage:
            strContent = @"[图片]";
        case WMIMessageTypeLocation:
            strContent = @"[位置]";
        default:
            break;
    }
    return strContent;
}

+ (NSString*)pathMake:(WMIMMessage*)msg{
    NSString *strContent = nil;
    switch (msg.msgType) {
        case WMIMessageTypeText:
            strContent = nil;
            break;
        case WMIMessageTypeAudio:
            strContent = [NSString stringWithFormat:@"%@/%@",RecordPath,msg.videoName];
            break;
        case WMIMessageTypeImage:
        {
            strContent = [NSString stringWithFormat:@"%@/%@",PicPath,msg.content.lastPathComponent];
            break;
        }
        case WMIMessageTypeLocation:
        {
            strContent = msg.content;
        }
        default:
            break;
    }
    return strContent;
}

+ (NSDateComponents *)dateComponentsFromDate:(NSDate *)date{
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:date];
}

+ (NSDateComponents *)dateComponentsFromSince1970:(int)itime{
    NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:itime];
    NSCalendar* calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    return [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond) fromDate:currentTime];
}

+ (void)skipOneChatVc:(WMIMSession*)sessionTem userId:(int)id vController:(UIViewController*)vc{
    // 跳聊天走起
    CSOneUserModel* model = [CSUsersModel instance].dicPreAccount[UserDicKey(id)];
    if (model == nil) {
        model = [[CSOneUserModel alloc] init];
        model.id = sessionTem.member.firstObject.id;
        model.name = sessionTem.member.firstObject.name;
    }else if ((sessionTem == nil) &&
              (model == nil)){
        return;
    }
    
    XZGroup *group = [[XZGroup alloc] init];
    group.gId = UserDicKey(model.id);
    group.gName = model.name;
    group.unReadCount = 2;
    group.lastMsgString = @"马化腾你等着!";
    XZChatViewController *chatVc = [[XZChatViewController alloc] init];
    chatVc.group                 = group;
    // 获取过去20条数据
    //    chatVc.dataSource
    WMIMSession *session = [[WMIMSession alloc] init];
    WMGroupMember *other = [[WMGroupMember alloc] init];
    other.id = model.id;
    other.name = model.name;
    [session.member addObject:other];
    session.sessionId = group.gId;
    session.conversationType = WMIMConversationTypeSingle;
    [[IMChatManageTool instance].msgDataManage saveSessionInfo:session];
    
    NSArray *msgArray = [[IMChatManageTool instance].msgDataManage messagesInSession:session message:nil limit:20];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970];
    NSDateComponents *selectComps = [DAYUtils dateComponentsFromDate:date];
    for (WMIMMessage *msg in msgArray) {
        BOOL bIsTimeLabel = NO;
        NSDateComponents *selectCompTem = [DAYUtils dateComponentsFromDate:[NSDate dateWithTimeIntervalSince1970:msg.createdTime]];
        if((selectComps.year > selectCompTem.year) ||
           (selectComps.month > selectCompTem.month) ||
           (selectComps.day > selectCompTem.day)){
            bIsTimeLabel = YES;
            selectComps = selectCompTem;
        }
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:[chatVc chatType:msg.msgType] content:[CSStatusTool contentMake:msg] path:[CSStatusTool pathMake:msg] from:msg.fromId to:UserDicKey(model.id) fileKey:nil isSender:[msg.toId isEqualToString:group.gId] isChatGroup:NO receivedSenderByYourself:NO isHaveTimeLabel:bIsTimeLabel];

        messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
        messageF.iTime = msg.createdTime;
        
        [chatVc.dataSource addObject:messageF];
    }
    chatVc.session = session;
    chatVc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:chatVc animated:YES];
}

+ (void)skipGroupChatVc:(LMRegisterSyncgroupModel*)model vController:(UIViewController*)vc{
    XZGroup *group = [[XZGroup alloc] init];
    group.gId = UserDicKey(model.id);
    group.gName = model.name;
    XZChatViewController *chatVc = [[XZChatViewController alloc] init];
    chatVc.group                 = group;
    // 获取过去20条数据
    //    chatVc.dataSource
    WMIMSession *session = [[WMIMSession alloc] init];
    session.sessionId = group.gId;
    session.groupName = model.name;
    session.owenid = model.owner;
    chatVc.groupModel = model;
    
    for (LMRegisterSyncgroupModel *tem in model.member) {
        WMGroupMember *memeber = [[WMGroupMember alloc] init];
        memeber.id = tem.id;
        memeber.name = tem.name;
        [session.member addObject:memeber];
    }
    session.conversationType = WMIMConversationTypeGroup;
    [[IMChatManageTool instance].msgDataManage saveSessionInfo:session];
    
    NSArray *msgArray = [[IMChatManageTool instance].msgDataManage messagesInSession:session message:nil limit:20];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[NSDate date].timeIntervalSince1970];
    NSDateComponents *selectComps = [DAYUtils dateComponentsFromDate:date];
    for (WMIMMessage *msg in msgArray) {
        BOOL bIsTimeLabel = NO;
        NSDateComponents *selectCompTem = [DAYUtils dateComponentsFromDate:[NSDate dateWithTimeIntervalSince1970:msg.createdTime]];
        if((selectComps.year > selectCompTem.year) ||
           (selectComps.month > selectCompTem.month) ||
           (selectComps.day > selectCompTem.day)){
            bIsTimeLabel = YES;
            selectComps = selectCompTem;
        }
        
        ICMessageFrame *messageF = [ICMessageHelper createMessageFrame:[chatVc chatType:msg.msgType] content:[CSStatusTool contentMake:msg] path:[CSStatusTool pathMake:msg] from:msg.fromId to:UserDicKey(model.id) fileKey:nil isSender:[msg.toId isEqualToString:group.gId]  isChatGroup:YES  receivedSenderByYourself:NO isHaveTimeLabel:bIsTimeLabel];
        
        messageF.model.message.deliveryState = ICMessageDeliveryState_Delivered;
        messageF.iTime = msg.createdTime;
        [chatVc.dataSource addObject:messageF];
    }
    chatVc.session = session;
    chatVc.hidesBottomBarWhenPushed = YES;
    [vc.navigationController pushViewController:chatVc animated:YES];
}
@end
