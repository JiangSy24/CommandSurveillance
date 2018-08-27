//
//  CSViewStyle.h
//  CloudSurveillance
//
//  Created by liangcong on 16/7/28.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CSViewStyle : NSObject

+ (void)initInputView:(UIView*)view;

+ (void)initInputViewRound:(UIView*)view;

+ (void)initInputView:(UIView*)view color:(UIColor*)color radiusSize:(CGFloat)fSize;

+ (UIView *)changeNavTitleByFontSize:(NSString *)strTitle;

+ (void)setSliedRightViewController:(UIViewController*)controller;

+ (void)setSliedRightViewForbidController:(UIViewController*)controller;

+ (void)setRegistBtnIsEnable:(BOOL)bStatus btn:(UIButton*)btn;

+ (void)setNavBarNoBorder:(UINavigationBar*)navigationBar;

+ (int)getLenTextField:(UITextField*)orTextField other:(UITextField*)otTextField charLen:(int)len;

+ (void)initInputView:(UIView*)view color:(UIColor*)color;

+ (UIView *)changeNavTitleByFontSizeEx:(NSString *)strTitle color:(UIColor*)color;
@end
