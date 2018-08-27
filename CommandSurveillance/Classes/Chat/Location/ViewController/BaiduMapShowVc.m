//
//  BaiduMapShowVc.m
//  LocationSend
//
//  Created by liangcong on 17/9/20.
//  Copyright © 2017年 Cocav. All rights reserved.
//

#import "BaiduMapShowVc.h"

@interface BaiduMapShowVc ()

@end

@implementation BaiduMapShowVc

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"BaiduMapShow"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.imageViewRect.size.width, 20)];
    label.text = self.selectModel.title;
    [self.view addSubview:label];
    UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, self.imageViewRect.size.width, 20)];
    address.text = self.selectModel.address;
    [self.view addSubview:address];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 104, self.imageViewRect.size.width, self.imageViewRect.size.height)];
    view.image = self.resultImage;
    [self.view addSubview:view];
    
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
