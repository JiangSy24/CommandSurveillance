//
//  CSChooseRootController.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/15.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSChooseRootController.h"

@implementation CSChooseRootController

+ (UIViewController*)chooseRootController{

    // 暂时没有自动登录了，哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈
    UIViewController* vc = nil;
//    NSFileManager *fm = [NSFileManager defaultManager];
//    if ([fm fileExistsAtPath:CZAccountFileName]) {
//        NSLog(@"fileExist");
//        // 存在就不是第一次登陆
//        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarController"];
//    } else {
//        NSLog(@"file not exist");
        vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
//    }
    // 以后如果有新特性页就耍一下
    return vc;
}

@end
