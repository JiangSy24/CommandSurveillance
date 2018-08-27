//
//  CSTabBarController.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/4.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSTabBarController.h"

@interface CSTabBarController ()<UIAlertViewDelegate>

@end

@implementation CSTabBarController

+ (instancetype)instance{

    UIViewController *vc = CSKeyWindow.rootViewController;
    if ([vc isKindOfClass:[CSTabBarController class]]) {
        return (CSTabBarController *)vc;
    }else{
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 检查版本 版本更新
//    [self judgeAPPVersion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *   判断app安装版本和商店版本的比较      版本更新
 *
 *    PS：还是介绍一下对应信息
 *    trackCensoredName = 审查名称;
 *    trackContentRating = 评级;
 *    trackId = 应用程序 ID;
 *    trackName = 应用程序名称;
 *    trackViewUrl = 应用程序介绍网址;
 *    userRatingCount = 用户评级;
 *    userRatingCountForCurrentVersion = 1;
 *    version = 版本号;
 */
-(void)judgeAPPVersion
{
    // 快捷方式获得session对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/lookup?id=1048992038"];
    // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                        NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
                                        
                                        NSError *errorJs;
                                        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorJs];
                                        NSDictionary *appInfo = (NSDictionary *)jsonObject;
                                        NSArray *infoContent = [appInfo objectForKey:@"results"];
                                        NSString *version = [[infoContent objectAtIndex:0] objectForKey:@"version"];
                                        
                                        NSLog(@"商店的版本是 %@",version);
                                        
                                        NSString *skipUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
                                        
                                        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
                                        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
                                        NSLog(@"当前的版本是 %@",currentVersion);
                                        
                                        if (![version isEqualToString:currentVersion]) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                // 跳转appstore
                                                [self skipAppStore:skipUrl];
                                            });
                                        }
                                        
                                    }];
    
    // 启动任务
    [task resume];
}

- (void)skipAppStore:(NSString*)strSkipUrl{
    // 初始化
    UIAlertController *alertDialog = [UIAlertController alertControllerWithTitle:@"是否更新新版本" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // 分别3个创建操作
    UIAlertAction *laterAction = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strSkipUrl]];
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // 取消按键
        
    }];
    
    // 添加操作（顺序就是呈现的上下顺序）
    [alertDialog addAction:laterAction];
    [alertDialog addAction:okAction];
    
    // 呈现警告视图
    [self presentViewController:alertDialog animated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    
    return [self.selectedViewController shouldAutorotate];
    
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    return [self.selectedViewController supportedInterfaceOrientations];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
    
}


@end
