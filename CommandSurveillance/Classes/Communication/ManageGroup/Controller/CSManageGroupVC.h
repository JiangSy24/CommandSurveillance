//
//  CSManageGroupVC.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/6.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSManageGroupVCDelegate <NSObject>
- (void)groupHadLeft;
@end
@interface CSManageGroupVC : UIViewController
@property (nonatomic,strong) NSMutableArray<CSOneUserModel*> *array;
@property (nonatomic,assign) int iGroupId;
@property (nonatomic,strong) LMRegisterSyncgroupModel *groupModel;
@property (nonatomic,strong) WMIMSession *session;
@property (nonatomic,weak) id<CSManageGroupVCDelegate> delegate;
+(instancetype)myTableViewController;
@end
