//
//  LMCallModel.h
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/7.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMUserIdModel.h"
// { "userids":["userid"]}
/*callstatus: 0-邀请中 1-通话中 2-已拒绝 3-已挂断 4-已离线
 "[\n   {\n      \"callstatus\" : 1,\n      \"userid\" : 26\n   },\n   {\n      \"callstatus\" : 1,\n      \"userid\" : 47\n   },\n   {\n      \"callstatus\" : 4,\n      \"userid\" : 61\n   }\n]\n"
 */
@interface LMCallModel : NSObject
@property (nonatomic,assign) int userid;
@property (nonatomic,assign) int callstatus;
@end
