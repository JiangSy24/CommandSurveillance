//
//  CSMainTabNavigation.m
//  CommunitySurveillance
//
//  Created by liangcong on 2018/2/27.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMainTabNavigation.h"
#import "UIImage+Image.h"

@interface CSMainTabNavigation ()

@end

@implementation CSMainTabNavigation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:CSColorZiSe] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = NO;//半透明
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
