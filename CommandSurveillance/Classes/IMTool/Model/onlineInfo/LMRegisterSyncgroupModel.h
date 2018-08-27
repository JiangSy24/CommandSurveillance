//
//  LMRegisterSyncgroupModel.h
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/6.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "result" : 0,
 "syncgroup" : [
         {
             "createtime" : 1505371511,
             "id" : 52,
             "member" : [
                     {
                         "id" : 3
                     },
                     {
                         "id" : 167
                     }
             ],
             "name" : "yhhj",
             "owner" : 167,
             "reserved1" : "",
             "reserved2" : "",
             "reserved3" : "",
             "reserved4" : ""
         },...],
 "syncuser" : [
         {
             "id" : 1,
             "maccode" : "a_864698030364174"
         },
         {
             "id" : 3,
             "maccode" : "VEYE-C768FE68-4562-4BD3-8465-D19E18BA70B4"
         }
         ]
 */
@interface LMRegisterSyncgroupModel : NSObject
@property (nonatomic,assign) int id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int owner;
@property (nonatomic,assign) int createtime;
@property (nonatomic,copy) NSString *reserved1;
@property (nonatomic,copy) NSString *reserved2;
@property (nonatomic,copy) NSString *reserved3;
@property (nonatomic,copy) NSString *reserved4;
@property (nonatomic,strong) NSMutableArray<LMRegisterSyncgroupModel*> *member;
@end
