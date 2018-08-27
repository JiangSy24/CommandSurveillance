//
//  AppDelegate.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/17.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "AppDelegate.h"
#import "CSNTESNotificationCenter.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface AppDelegate (){
    BMKMapManager* _mapManager;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [AMapServices sharedServices].apiKey = @"6a5a27cde24fbe6b597f5fefe91a7b41";
//    _mapManager = [[BMKMapManager alloc]init];
//    /**
//     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
//     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
//     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
//     */
//    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
//        NSLog(@"经纬度类型设置成功");
//    } else {
//        NSLog(@"经纬度类型设置失败");
//    }
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [_mapManager start:@"DpXfr0aYur3nuXbx3GhtqYV3oR5sSLcK"  generalDelegate:nil];
//    if (!ret) {
//        NSLog(@"manager start failed!");
//    }

    NSString *pathPicRoot = PicPath;
    NSLog(@"PicPath : %@", pathPicRoot);
    
    NSFileManager *picfm = [NSFileManager defaultManager];
    BOOL isPicDir;
    BOOL isPicExists = [picfm fileExistsAtPath:pathPicRoot isDirectory:&isPicDir];
    if (!isPicExists) {
        [picfm createDirectoryAtPath:pathPicRoot withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    // Override point for customization after application launch.
    [[CSNTESNotificationCenter sharedCenter] start];
    // 创建文件录像目录，录像配置文件目录，点击保存上传都会保存信息
    NSString *pathRoot = RecordPath;
    NSLog(@"path : %@", pathRoot);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL isExists = [fm fileExistsAtPath:pathRoot isDirectory:&isDir];
    if (!isExists) {
        [fm createDirectoryAtPath:pathRoot withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // 解决下边框黑线的宝贝
    [[UINavigationBar appearance]  setBackgroundImage:[UIImage imageNamed:@"navgation_barnar"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    // 开始就是竖屏
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    // 搞后台定位
    //    [self setBackgraoundLocation];
    
    // Override point for customization after application launch.
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
//    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
//    manager.enableAutoToolbar = NO;//这个是它自带键盘工具条开关
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置窗口的根控制器
    self.window.rootViewController = [CSChooseRootController chooseRootController];
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc{
    
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}


@end
