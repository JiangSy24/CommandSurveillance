//
//  CSGroupUserShowCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSGroupUserShowCell.h"
#import "CSUserHeaderView.h"

@interface CSGroupUserShowCell()
@property (weak, nonatomic) IBOutlet UIView *showBoxView;

@end
@implementation CSGroupUserShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self drawAllControl];
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
    CSGroupUserShowCell *subView = [[bundle loadNibNamed:@"CSGroupUserShowCell" owner:nil options:nil] lastObject];
    
    return subView;
}

- (void)setArray:(NSArray *)array{
    _array = array;
    for (UIView *sub in self.showBoxView.subviews) {
        [sub removeFromSuperview];
    }
    // 5 个btn 好烦，还给算布局，妈蛋的
    NSInteger iCount = self.array.count < 5 ? self.array.count : 5;
    for (int i = 0; i < iCount; i++) {
        CSUserHeaderView *hview = [CSUserHeaderView appInfoView];
        CSOneUserModel *model = self.array[i];
        hview.userName.text = [CSStatusTool getShowUserName:model.name];
        [CSViewStyle initInputViewRound:hview];
        hview.frame = CGRectMake(i * (40+10), 0, 40, 40);
        [self.showBoxView addSubview:hview];
    }
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.tag = 1;
    btnAdd.frame = CGRectMake(iCount * (40+10), 0, 40, 40);
    [btnAdd setImage:[UIImage imageNamed:@"group_add_people.png"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(changeUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showBoxView addSubview:btnAdd];
    
    UIButton *btnSub = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSub.tag = 2;
    btnSub.frame = CGRectMake((iCount + 1) * (40+10), 0, 40, 40);
    [btnSub setImage:[UIImage imageNamed:@"group_sbtruct_people.png"] forState:UIControlStateNormal];
    [btnSub addTarget:self action:@selector(changeUserClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.showBoxView addSubview:btnSub];
    
    self.munsLabel.text = [NSString stringWithFormat:@"%ld人",self.array.count];
}

- (void)changeUserClick:(id)sender{
    UIButton *btn = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeUserClick:)]) {
        [self.delegate changeUserClick:(btn.tag == 1)];
    }
}

+ (instancetype)tempTableViewCellWith:(UITableView *)tableView{
    NSString *identifier = @"GroupUserShowCell";//对应xib中设置的identifier
    
    CSGroupUserShowCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CSGroupUserShowCell" owner:self options:nil] lastObject];
    }
    
    return cell;
    
}
@end
