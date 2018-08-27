//
//  CSCommunicationGroupCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCommunicationGroupCell : UITableViewCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImage;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *twoImage;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thrImage;
@property (weak, nonatomic) IBOutlet UILabel *thrLabel;
@end
