//
//  CSMoreVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSMoreVController.h"

@interface CSMoreVController ()

@end

@implementation CSMoreVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    title.text = @"我的";
    title.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.f];;
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title;
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
