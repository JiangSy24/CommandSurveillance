//
//  CSCmChoiceVc.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSCmChoiceVcDelegate <NSObject>
- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray;
@end
@interface CSCmChoiceVc : UIViewController
@property (nonatomic, weak) id<CSCmChoiceVcDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<CSOneUserModel*> *selectArray;

+(instancetype)myTableViewController;
@end
