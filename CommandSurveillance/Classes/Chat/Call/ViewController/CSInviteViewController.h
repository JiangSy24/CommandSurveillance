//
//  CSInviteViewController.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/8/17.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSInviteViewController : UIViewController
@property (nonatomic,strong) NSMutableArray<CSOneUserModel*> *array;
@property (nonatomic,assign) int iGroupId;
@property (nonatomic,strong) LMRegisterSyncgroupModel *groupModel;
@property (nonatomic,strong) WMIMSession *session;
+(instancetype)myTableViewController;
@end
