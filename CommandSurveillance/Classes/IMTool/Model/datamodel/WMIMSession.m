//
//  WMIMSession.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "WMIMSession.h"
@implementation WMGroupMember
- (id)copyWithZone:(NSZone *)zone
{
    WMGroupMember * dog = [[self class] allocWithZone:zone];
    dog.id = self.id;
    dog.name = [NSString stringWithFormat:@"%@",self.name];
    return dog;
}


- (id)mutableCopyWithZone:(NSZone *)zone
{
    
    WMGroupMember * dog = [[self class] allocWithZone:zone];
    dog.id = self.id;
    dog.name = [NSString stringWithFormat:@"%@",self.name];
    return dog;
}

@end

@implementation WMIMSession

/**
 *  通过id和type构造会话对象
 *
 *  @param createdTime   创建时间
 *  @param sessionType 会话类型
 *
 *  @return 会话对象实例
 */
+ (instancetype)session:(int)createdTime
                   type:(WMIMConversationType)sessionType
                   toId:(int)toId{
    
    WMIMSession *session = [[WMIMSession alloc] init];
    if (sessionType == WMIMConversationTypeSingle) {
        session.sessionId = [NSString md5String16:[NSString stringWithFormat:@"%d",toId]];
    }else{
        NSString *sessionId = [NSString md5String16:[NSString stringWithFormat:@"%d%d",createdTime,sessionType]];
        session.sessionId = sessionId;
    }
    session.createdTime = createdTime;
    session.conversationType = sessionType;
    return session;
}

+(NSDictionary *)bg_objectClassInArray{
    return @{@"member":[WMGroupMember class]};
}

- (NSMutableArray<WMGroupMember*>*)member{
    if (_member == nil) {
        _member = [NSMutableArray array];
    }
    return _member;
}

@end
