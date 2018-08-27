//
//  CSRegisterParam.h
//  CloudSurveillance
//
//  Created by liangcong on 16/11/4.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSRegisterParam : NSObject

@property (nonatomic,assign) int    msgid; //  msgid:消息ID，参见HttpMsgId定义

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,copy) NSString *verifCode;

@property (nonatomic,copy) NSString *pswd;

@end
