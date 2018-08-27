//
//  CSChartUserVController.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/25.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSChartUserVController.h"

@interface CSChartUserVController ()

@end

@implementation CSChartUserVController

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)skipVc:(id)sender {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"ChartUserVController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
