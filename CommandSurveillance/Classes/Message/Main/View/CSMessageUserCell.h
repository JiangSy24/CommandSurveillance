//
//  CSMessageUserCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSMessageUserCell : UITableViewCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *lastMsgContent;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userHeadLabel;
@property (assign, nonatomic) int iUnCount;
@end
