//
//  CSMessageGroupMoreCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMessageGroupMoreCell.h"
@interface CSMessageGroupMoreCell()
@property (weak, nonatomic) IBOutlet UIView *logoViewBox;
@property (weak, nonatomic) IBOutlet UIView *noReadViewBox;
@property (weak, nonatomic) IBOutlet UILabel *unReadNumLabel;
@end
@implementation CSMessageGroupMoreCell

- (void)setIUnCount:(int)iUnCount{
    _iUnCount = iUnCount;
    if (iUnCount == 0) {
        self.noReadViewBox.hidden = YES;
    } else {
        self.noReadViewBox.hidden = NO;
        self.unReadNumLabel.text = [NSString stringWithFormat:@"%d",iUnCount];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self drawAllControl];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)drawAllControl{
    
    // 5 个btn 好烦，还给算布局，妈蛋的
    // 320 * 480
    // 320 50
    
    // 375 50
    
    // 414 50
    [CSViewStyle initInputViewRound:self.logoViewBox];
    [CSViewStyle initInputViewRound:self.noReadViewBox];
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView{
    NSString *identifier = @"MessageGroupMoreCell";//对应xib中设置的identifier
    
    CSMessageGroupMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSMessageGroupMoreCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}
@end
