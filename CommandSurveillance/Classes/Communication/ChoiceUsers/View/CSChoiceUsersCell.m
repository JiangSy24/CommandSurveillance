//
//  CSChoiceUsersCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSChoiceUsersCell.h"
@interface CSChoiceUsersCell()
@property (weak, nonatomic) IBOutlet UIView *logoViewBox;

@end
@implementation CSChoiceUsersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [CSViewStyle initInputViewRound:self.logoViewBox];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (instancetype)appInfoView
{
    //从xib中加载subview
    NSBundle *bundle = [NSBundle mainBundle];
    
    //加载xib中得view
    CSChoiceUsersCell *subView = [[bundle loadNibNamed:@"CSChoiceUsersCell" owner:nil options:nil] lastObject];
    
    return subView;
}

- (void)drawAllControl{
    
    // 5 个btn 好烦，还给算布局，妈蛋的
    // 320 * 480
    // 320 50
    
    // 375 50
    
    // 414 50
    
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView{
    NSString *identifier = @"choiceuser";//对应xib中设置的identifier
    
    CSChoiceUsersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSChoiceUsersCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}

@end
