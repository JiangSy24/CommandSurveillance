//
//  CSTextField.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/1.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSTextField.h"

@implementation CSTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init{
    self = [super init];
    self.font = [UIFont systemFontOfSize:14];
    return self;
}
- (void) deleteBackward{
    [super deleteBackward];
    // 目前都是清空处理
    self.text = @"";
    if (self.csdelegate && [self.csdelegate respondsToSelector:@selector(deleteBackward:)]) {
        [self.csdelegate deleteBackward:self];
    }
}

- (BOOL)isEmpty
{
    return self.text.length == 0;
}
- (BOOL)validateEmail
{
    return [self validateWithRegExp: @"^[a-zA-Z0-9]{4,}@[a-z0-9A-Z]{2,}\\.[a-zA-Z]{2,}$"];
}
- (BOOL)validateAuthen
{
    return [self validateWithRegExp: @"^\\d{5,6}$"];
}
- (BOOL)validatePassword
{
    NSString * length = @"^.{5,7}$";         //长度
//    NSString * number = @"^\\w*\\d+\\w*$";      //数字
//    NSString * lower = @"^\\w*[a-z]+\\w*$";      //小写字母
//    NSString * upper = @"^\\w*[A-Z]+\\w*$";     //大写字母
//    return [self validateWithRegExp: length] && [self validateWithRegExp: number] && [self validateWithRegExp: lower] && [self validateWithRegExp: upper];
    return [self validateWithRegExp: length];
}
- (BOOL)validatePhoneNumber
{
    NSString * reg = @"^1\\d{10}$";
    return [self validateWithRegExp: reg];
}
- (BOOL)validateWithRegExp: (NSString *)regExp
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject: self.text];
}

@end
