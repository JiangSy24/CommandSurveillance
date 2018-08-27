//
//  CSLoginIPVController.h
//  CloudSurveillance
//
//  Created by liangcong on 17/6/9.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CSLoginIPVCDelegate<NSObject>
- (void)getIp:(NSString*)ip port:(int)port;
@end

@interface CSLoginIPVController : UIViewController
@property (nonatomic,weak) id<CSLoginIPVCDelegate>  delegate;
+(instancetype)myTableViewController;
@property (copy, nonatomic) NSString *strip;
@end
