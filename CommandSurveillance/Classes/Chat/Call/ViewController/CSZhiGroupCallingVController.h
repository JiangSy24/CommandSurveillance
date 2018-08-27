//
//  CSZhiGroupCallingVController.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/18.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSZhiGroupCallingVController : UIViewController
@property (nonatomic, assign) int chatId;
@property (nonatomic, assign) int sponsorid;
@property (nonatomic, strong) NSMutableArray<WMGroupMember*> *callingArray;
//@property (nonatomic, assign) WM_IM_CallType chattype;
@property (nonatomic, assign) int groupId;
+(instancetype)myTableViewController;

@property (nonatomic, assign) BOOL bSoundOffBtnisSelect;
@property (nonatomic, assign) BOOL bHandsFreebSelect;

@property (nonatomic, assign) BOOL bIsCalling;//YES是通话中

@property (nonatomic, assign) BOOL bIsMicCalling;//YES是mic通话
@end
