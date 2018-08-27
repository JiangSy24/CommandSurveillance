//
//  CSTextField.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/1.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSTextField;
@protocol CSTextFieldDelegate <NSObject>

- (void) deleteBackward:(CSTextField*)textFiled;

@end

@interface CSTextField : UITextField

@property (weak,nonatomic) id<CSTextFieldDelegate>  csdelegate;

/*! 判断文本框是否为空（非正则表达式）*/
- (BOOL)isEmpty;
/*! 判断邮箱是否正确*/
- (BOOL)validateEmail;
/*! 判断验证码是否正确*/
- (BOOL)validateAuthen;
/*! 判断密码格式是否正确*/
- (BOOL)validatePassword;
/*! 判断手机号码是否正确*/
- (BOOL)validatePhoneNumber;
/*! 自己写正则传入进行判断*/
- (BOOL)validateWithRegExp: (NSString *)regExp;

@end
