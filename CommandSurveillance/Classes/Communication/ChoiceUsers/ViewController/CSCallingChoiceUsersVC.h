//
//  CSCallingChoiceUsersVC.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/14.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSCallingChoiceUsersVCDelegate <NSObject>
- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray;
@end
@interface CSCallingChoiceUsersVC : UIViewController
+(instancetype)myTableViewController;
@property (nonatomic,assign) int groupId;
@property (nonatomic, weak) id<CSCallingChoiceUsersVCDelegate> delegate;
@property (nonatomic,strong) NSMutableArray<WMGroupMember*>* joinInCallingPeople;//通话中的用户，也就是要搞禁选的。
@end
