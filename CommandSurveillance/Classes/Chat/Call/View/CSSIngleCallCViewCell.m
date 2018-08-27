//
//  CSSIngleCallCViewCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/12.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSSIngleCallCViewCell.h"

@implementation CSSIngleCallCViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerView.layer.borderWidth = 2;
    self.headerView.layer.cornerRadius = self.headerView.height / 2;
    self.headerView.layer.masksToBounds = YES;
}
@end
