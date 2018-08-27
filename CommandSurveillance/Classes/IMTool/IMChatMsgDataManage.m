//
//  IMChatMsgDataManage.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "IMChatMsgDataManage.h"

@implementation IMChatMsgDataManage
/**
 *  存数据到数据库
 *
 *  @param message 聊天消息
 */
- (void)saveMessage:(WMIMMessage*_Nonnull)message{
    
}

/**
 *  从本地db读取一个会话里某条消息之前的若干条的消息
 *
 *  @param session 消息所属的会话
 *  @param message 当前最早的消息,没有则传入nil
 *  @param limit   个数限制
 *
 *  @return 消息列表，按时间从小到大排列
 */
- (nullable NSArray<WMIMMessage *> *)messagesInSession:(WMIMSession *_Nonnull)session
                                               message:(nullable WMIMMessage *)message
                                                 limit:(NSInteger)limit{
    NSArray *array = nil;
    if (session.conversationType == WMIMConversationTypeSingle) {
        array = [WMIMMessage bg_find:UserDbName(session.sessionId.intValue) limit:limit orderBy:@"createdTime" desc:NO];
    }else{
        array = [WMIMMessage bg_find:TableDbName(session.sessionId.intValue) limit:limit orderBy:@"createdTime" desc:NO];
    }

    return array;
}

/**
 存储session，如果存在更新，如果不存在则保存
 
 @param session 会话
 */
- (void)saveSessionInfo:(WMIMSession *_Nonnull)session{
    session.bg_tableName = SessionDbName;
    session.createdTime = [NSDate date].timeIntervalSince1970;
    NSString *sql = [NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"sessionId"),session.sessionId,bg_sqlKey(@"conversationType"),@(session.conversationType)];
    NSArray *mmArr = [WMIMSession bg_find:SessionDbName where:sql];
    if (mmArr.count == 0) {
        [session bg_save];
    }else{
        [session bg_updateWhere:sql];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NoticLoginReflash object:nil];
}

/**
 *  从本地db读取会话,目前只支持全部获取
 *
 *  @param limit   个数限制
 *
 */
- (void)sessionsInDblimit:(NSInteger)limit complete:(void (^)(NSArray<WMIMSession *>* sessionArray))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray<WMIMSession*> *mmArr = [WMIMSession bg_find:SessionDbName where:nil];
        for (WMIMSession *model in mmArr) {
            NSString *dbName = nil;
            if (model.conversationType == WMIMConversationTypeSingle) {
                dbName = UserDbName(model.sessionId.intValue);
            }else{
                dbName = TableDbName(model.sessionId.intValue);
            }
            
            WMIMMessage *last = [WMIMMessage bg_lastObject:dbName];
            if (nil != last) {
                model.message = last;
                NSString *sql = [NSString stringWithFormat:@"where %@=%@ ",bg_sqlKey(@"bIsRead"),@(0)];
                NSArray *arr = [WMIMMessage bg_find:dbName where:sql];
                model.iunReadCount = (int)arr.count;
            }
        }
        
        if (complete) {
            complete(mmArr);
        }
        
    });
}
/*
 1.将People类中name等于"马云爸爸"的数据的name更新为"马化腾":
 where = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"name"),bg_sqlValue(@"马化腾"),bg_sqlKey(@"name"),bg_sqlValue(@"马云爸爸")];
 */
//+(BOOL)bg_update:(NSString* _Nullable)tablename where:(NSString* _Nonnull)where;
- (void)updateAllmessagesStatusInSession:(WMIMSession *_Nonnull)session{
    
    NSString *dbName = nil;
    if (session.conversationType == WMIMConversationTypeSingle) {
        dbName = UserDbName(session.sessionId.intValue);
    }else{
        dbName = TableDbName(session.sessionId.intValue);
    }
    
    NSString *where = [NSString stringWithFormat:@"set %@=%@ where %@=%@",bg_sqlKey(@"bIsRead"),@(1),bg_sqlKey(@"bIsRead"),@(0)];
    [WMIMMessage bg_update:dbName where:where];
}

/**
 *  删除某个会话的所有消息
 *
 *  @param session 待删除会话
 *  @param option 删除消息选项
 */
- (void)deleteAllmessagesInSession:(WMIMSession *_Nonnull)session
                            option:(nullable WMIMDeleteMessagesOption *)option{
    
    NSString* strDbName = nil;
    if (session.conversationType == WMIMConversationTypeGroup) {
        strDbName = TableDbName(session.sessionId.intValue);
    } else if (session.conversationType == WMIMConversationTypeSingle){
        strDbName = UserDbName(session.sessionId.intValue);
    }
    
    if (option.removeTable) {
        // 删除数据表，目前就用到这一个。
        //    strDbName = TableDbName(model.groupid);
        [WMIMSession bg_drop:strDbName];
    }
    
    if (option.removeSession) {
        NSString *sql = [NSString stringWithFormat:@"where %@=%@ and %@=%@",bg_sqlKey(@"sessionId"),session.sessionId,bg_sqlKey(@"conversationType"),@(session.conversationType)];
        [WMIMSession bg_delete:SessionDbName where:sql];
    }
}
@end
