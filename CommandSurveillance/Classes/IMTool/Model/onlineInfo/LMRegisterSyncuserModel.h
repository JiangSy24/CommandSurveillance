//
//  LMRegisterSyncuserModel.h
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/6.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
//"syncuser":[{"id", "maccode"}], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]
@interface LMRegisterSyncuserModel : NSObject
@property (nonatomic,assign) int id;
@property (nonatomic,copy) NSString *maccode;


@property (nonatomic,copy) NSString *signature;
@end
