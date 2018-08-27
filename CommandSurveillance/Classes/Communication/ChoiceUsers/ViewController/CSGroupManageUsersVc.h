//
//  CSGroupManageUsersVc.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/9.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSGroupManageUsersVcDelegate <NSObject>
- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray bIsAdd:(BOOL)bIsAdd;
@end
@interface CSGroupManageUsersVc : UIViewController
@property (nonatomic, weak) id<CSGroupManageUsersVcDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<CSOneUserModel*> *groupArray;
@property (nonatomic, assign) BOOL bIsAdd;// 是否是添加成员，YES是添加成员
@property (nonatomic, assign) int iGroupId;//组id
@property (nonatomic, strong) LMRegisterSyncgroupModel *groupModel;
+(instancetype)myTableViewController;
@end
