//
//  CSCommunicationCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/23.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationCell.h"
@interface CSCommunicationCell ()
@property (weak, nonatomic) IBOutlet UIView *logoViewBox;
@property (weak, nonatomic) IBOutlet UIView *logoinStatusView;
@end

@implementation CSCommunicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [CSViewStyle initInputViewRound:self.logoViewBox];
    [CSViewStyle initInputViewRound:self.logoinStatusView];
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
    CSCommunicationCell *subView = [[bundle loadNibNamed:@"VSChoiceDevCell" owner:nil options:nil] lastObject];
    
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
    NSString *identifier = @"user";//对应xib中设置的identifier
    
    CSCommunicationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSCommunicationCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}

@end
