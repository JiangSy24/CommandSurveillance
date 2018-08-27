//
//  CSComGroupMoreCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSComGroupMoreCell.h"
@interface CSComGroupMoreCell()
@property (weak, nonatomic) IBOutlet UIView *logoViewBox;

@end
@implementation CSComGroupMoreCell

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
    CSComGroupMoreCell *subView = [[bundle loadNibNamed:@"CSComGroupMoreCell" owner:nil options:nil] lastObject];

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
    NSString *identifier = @"groupmore";//对应xib中设置的identifier
    CSComGroupMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSComGroupMoreCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}

@end
