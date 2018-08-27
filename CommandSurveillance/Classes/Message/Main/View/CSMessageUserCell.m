//
//  CSMessageUserCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMessageUserCell.h"
@interface CSMessageUserCell()
@property (weak, nonatomic) IBOutlet UIView *logoViewBox;
@property (weak, nonatomic) IBOutlet UIView *noReadView;
@property (weak, nonatomic) IBOutlet UILabel *unReadNumLabel;

@end
@implementation CSMessageUserCell

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
    [CSViewStyle initInputViewRound:self.noReadView];
}

- (void)setIUnCount:(int)iUnCount{
    _iUnCount = iUnCount;
    if (iUnCount == 0) {
        self.noReadView.hidden = YES;
    } else {
        self.noReadView.hidden = NO;
        self.unReadNumLabel.text = [NSString stringWithFormat:@"%d",iUnCount];
    }
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView{
    NSString *identifier = @"MessageUserCell";//对应xib中设置的identifier
    
    CSMessageUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSMessageUserCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}
@end
