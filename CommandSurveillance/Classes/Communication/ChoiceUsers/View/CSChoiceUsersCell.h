//
//  CSChoiceUsersCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSChoiceUsersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeader;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView;
@end
