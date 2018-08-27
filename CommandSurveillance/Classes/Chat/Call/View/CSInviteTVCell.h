//
//  CSInviteTVCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/8/20.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSInviteTVCellDelegate <NSObject>
- (void)inviteModel:(int)model;
- (void)callModel:(int)model;
@end

@interface CSInviteTVCell : UITableViewCell
@property (nonatomic,weak) id<CSInviteTVCellDelegate> delegate;
@end
