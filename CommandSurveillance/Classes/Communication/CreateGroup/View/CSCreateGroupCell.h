//
//  CSCreateGroupCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/6.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSCreateGroupCellDelegate <NSObject>
- (void)doneGroupName:(NSString*)strName;
@end
@interface CSCreateGroupCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (nonatomic, weak) id<CSCreateGroupCellDelegate> delegate;
@end
