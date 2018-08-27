//
//  CSCreateGroupCell.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/6.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCreateGroupCell.h"

@implementation CSCreateGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.groupName.delegate = self;
    self.groupName.returnKeyType = UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//实现UITextField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];//取消第一响应者
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneGroupName:)]) {
        [self.delegate doneGroupName:textField.text];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(doneGroupName:)]) {
        [self.delegate doneGroupName:textField.text];
    }
}
@end
