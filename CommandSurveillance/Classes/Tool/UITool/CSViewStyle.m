//
//  CSViewStyle.m
//  CloudSurveillance
//
//  Created by liangcong on 16/7/28.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSViewStyle.h"

@implementation CSViewStyle

/**
 *  这个函数是设置view边框圆角的
 *
 *  @param view 要设置的textview
 */
+ (void)initInputView:(UIView*)view{
    view.layer.borderColor = CSCGColor(194, 200, 204);
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

/**
 *  这个函数是设置view边框圆角的
 *
 *  @param view 要设置的textview
 */
+ (void)initInputViewRound:(UIView*)view{
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 0;
    view.layer.cornerRadius = view.height / 2;
    view.layer.masksToBounds = YES;
}

+ (void)initInputView:(UIView*)view color:(UIColor*)color{
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
}

+ (void)initInputView:(UIView*)view color:(UIColor*)color radiusSize:(CGFloat)fSize {
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = fSize;
    view.layer.masksToBounds = YES;
}

/**
 *  设置navtitle的样式，为什么不在navgation中设置，因为不好使，为什么不设置titletext内容，因为显示一半
 *
 *  @param strTitle 要显示的文字
 *
 *  @return 返回修改后的label
 */
+ (UIView *) changeNavTitleByFontSizeEx:(NSString *)strTitle color:(UIColor*)color
{
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName: @"Helvetica" size: 16];
    titleLabel.textColor = color;//设置文本颜色
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = strTitle;
    return titleLabel;
}

/**
 *  设置navtitle的样式，为什么不在navgation中设置，因为不好使，为什么不设置titletext内容，因为显示一半
 *
 *  @param strTitle 要显示的文字
 *
 *  @return 返回修改后的label
 */
+ (UIView *) changeNavTitleByFontSize:(NSString *)strTitle
{
    //自定义标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName: @"Helvetica" size: 16];
    titleLabel.textColor = [UIColor whiteColor];//设置文本颜色
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = strTitle;
    return titleLabel;
}

// 设置右滑
+ (void)setSliedRightViewController:(UIViewController*)controller{
    // Do any additional setup after loading the view.
    __weak typeof(controller) weakSelf = controller;
    if([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        controller.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    //判断是否为第一个view
    if (controller.navigationController && [controller.navigationController.viewControllers count] == 1) {
        controller.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

// 设置右滑失禁
+ (void)setSliedRightViewForbidController:(UIViewController*)controller{
    // Do any additional setup after loading the view.
    //开启ios右滑返回
    if([controller.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        controller.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

/**
 *  摁钮置灰
 */
+ (void)setRegistBtnIsEnable:(BOOL)bStatus btn:(UIButton*)btn{
    btn.backgroundColor = bStatus ? CSColorBtnBule: CSColorBtnGray;
    btn.enabled = bStatus;
}


/**
 *  设置导航无底框
 *
 *  @param navigationBar 
 */
+ (void)setNavBarNoBorder:(UINavigationBar*)navigationBar{
    // 设置导航无底框
    [navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc]init]];
}


+ (int)getLenTextField:(UITextField*)orTextField other:(UITextField*)otTextField charLen:(int)len{
    return ((orTextField.tag == otTextField.tag) ? (orTextField.text.length + len) : orTextField.text.length);
}


@end
