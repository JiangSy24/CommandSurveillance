//
//  CSNTESNotificationCenter.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/8.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMIMSession.h"
@interface CSNTESNotificationCenter : NSObject
+ (instancetype)sharedCenter;
- (void)start;

/**
 小化

 @param bCalling 是否在通话中
 @param memebers 通话中的数组,可以为空,单人不用传
 */

- (void)showMinisCalling:(BOOL)bCalling chatid:(int)chatid sponsorid:(int)sponsorid SoundOff:(BOOL)bSoundOff HandsFree:(BOOL)bHandsFree sessionType:(WM_IM_CallType)type callingMemebers:(NSArray<WMGroupMember*>*)memebers groupId:(int)groupId;

- (BOOL)miniCallIsShow;
@end
