//
//  CSCommunicationCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/23.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCommunicationCell : UITableViewCell

/**
 *  @author god~long, 16-04-03 15:04:19
 *
 *  初始化Cell的方法
 *
 *  @param tableView 对应的TableView
 *  @param indexPath 对应的indexPath
 *
 *  @return TempTableViewCell
 */
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageOne;
@property (weak, nonatomic) IBOutlet UIView *logoinStatus;
@property (weak, nonatomic) IBOutlet UILabel *nameLabelOne;
@end
