//
//  CSSingleCallingVController.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/9.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSSingleCallingVController : UIViewController
@property (nonatomic, assign) int chatId;
@property (nonatomic, assign) int sponsorid;
@property (nonatomic, assign) int toUserid;
//@property (nonatomic, assign) WM_IM_CallType chattype;

@property (nonatomic, assign) BOOL bIsCalling;//YES是通话中

@property (nonatomic, assign) BOOL bSoundOffBtnisSelect;
@property (nonatomic, assign) BOOL bHandsFreebSelect;

+(instancetype)myTableViewController;
@end
