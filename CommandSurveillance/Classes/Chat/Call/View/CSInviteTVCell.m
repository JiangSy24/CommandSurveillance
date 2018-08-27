//
//  CSInviteTVCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/8/20.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSInviteTVCell.h"

@implementation CSInviteTVCell
- (IBAction)callModel:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl*)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(callModel:)]) {
        [self.delegate callModel:(int)segmented.selectedSegmentIndex];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteChange:(id)sender {
    UISegmentedControl *segmented = (UISegmentedControl*)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(inviteModel:)]) {
        [self.delegate inviteModel:(int)segmented.selectedSegmentIndex];
    }
}

@end
