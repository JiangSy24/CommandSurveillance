//
//  CSGroupUserShowCell.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSGroupUserShowCellDelegate <NSObject>
- (void)changeUserClick:(BOOL)bIsAdd;
@end
@interface CSGroupUserShowCell : UITableViewCell
+ (instancetype)tempTableViewCellWith:(UITableView *)tableView;
@property (nonatomic,copy) NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *munsLabel;
@property (nonatomic,weak) id<CSGroupUserShowCellDelegate> delegate;
@end
