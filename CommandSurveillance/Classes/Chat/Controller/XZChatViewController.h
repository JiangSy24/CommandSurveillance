//
//  XZChatViewController.h
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICChatHearder.h"
#import "WMIMMessage.h"

@interface XZChatViewController : UIViewController

@property (nonatomic, strong) XZGroup *group;
@property (nonatomic, strong) WMIMSession *session;
@property (nonatomic, strong) LMRegisterSyncgroupModel *groupModel;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;

- (NSString*)chatType:(WMIMessageType)type;
@end
