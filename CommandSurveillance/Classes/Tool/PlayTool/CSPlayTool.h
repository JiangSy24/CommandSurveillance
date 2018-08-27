//
//  CSPlayTool.h
//  CloudSurveillance
//
//  Created by liangcong on 16/9/2.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CSWMPlayerView.h"
#import "PlatformSdk_i.h"
#import "JsyPlayerView.h"
#import "VLinkerDef.h"
#import "VSDataCache.h"

typedef struct GroupInfo{
    NSInteger iAllOnline;
    NSInteger iAllDevCount;
}stGroupInfo;

@interface CSAlarmImageModel : NSObject
@property (nonatomic, assign) int iCreateTime;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) int iResId;
@end

@interface CSAlarmVedioModel : NSObject
//@property (nonatomic, assign) int iChannel;
//@property (nonatomic, assign) int iDev;
@property (nonatomic, assign) int iResId;
@property (nonatomic, copy) NSString *url;
@end

@interface CSAlarmModel :NSObject
@property (nonatomic, copy) NSString *strGetTime;
@property (nonatomic, copy) NSString *strDevName;
@property (nonatomic, copy) NSString *strAlarmType;
@property (nonatomic, assign) int alarmType;
@property (nonatomic, strong) NSMutableArray<CSAlarmImageModel*> *imageArr;
@property (nonatomic, strong) NSMutableArray<CSAlarmVedioModel*> *vedioArr;
@end

@interface CSWifiModel :NSObject
@property (nonatomic, copy) NSString *strGetTime;
@property (nonatomic, copy) NSString *strDevName;
@property (nonatomic, copy) NSString *strMacCode;
@end

@interface CSPlayModel :NSObject
//@property (nonatomic, assign) int devId;    // in
//@property (nonatomic, assign) int channelId;    //  in
@property (nonatomic, assign) int iResId;
@property (nonatomic, assign) int playerId; //out
@property (nonatomic, assign) HANDLE displayHandle; // out
@property (nonatomic, assign) int devType;  //  in
@property (nonatomic, assign) int iQuality; // in 0主子码流 1是子码流
@property (nonatomic, strong) CSWMPlayerView* displayView;  // in
@property (nonatomic, copy) NSString *strAllName;
@property (nonatomic, weak) VSResListModel *model;

@property (nonatomic, assign) int iTag;     //  第几个屏幕，默认0是第一个

@property (copy, nonatomic) void (^playSuccess)();
@property (copy, nonatomic) void (^playFailure)();

@end

@interface CSPlayTool : NSObject

//@property (nonatomic, strong) MBProgressHUD *hud;

//@property (nonatomic,weak) CSWMPlayerView *displayView;

@property (copy, nonatomic) void (^passwordSuccess)();
@property (copy, nonatomic) void (^passwordFail)();

@property (copy, nonatomic) void (^searchAlarmSuccess)();
@property (copy, nonatomic) void (^searchAlarmFail)();

@property (copy, nonatomic) void (^searchListSuccess)(bool bFinish, const char* pResListBuf, const void *pUserData);
@property (copy, nonatomic) void (^searchListFail)();

- (void)LoginUser:(NSString*)userName pwd:(NSString*)pwd hudToView:(UIView*)hudview url:(CSUrlString*)url success:(void (^)())success failure:(void (^)())failure;

@property (nonatomic, copy) NSString *snapName;

@property (nonatomic, strong) NSMutableArray<CSWifiModel*> *arraytMacModel;

@property (nonatomic, strong) NSMutableArray<CSAlarmModel*> *arraytAlarmModel;

@property (nonatomic, strong) NSMutableArray<CSAlarmModel*> *arraySearchAlarm;
+ (instancetype)instance;

- (void)startPlayEx:(CSPlayModel*)playModel success:(void (^)())success failure:(void (^)())failure; //开始

- (void)stopPlay:(CSPlayModel*)playModel;           // 停止

- (void)saveDevInfo;        //  保存dev信息

- (int)makeSnap:(CSPlayModel*)playModel rootPath:(NSString*)strPath;           // 截图

- (int)makeSnapEx:(CSPlayModel*)playModel rootPath:(NSString*)strPath snapName:(NSString*)snapName;

- (NSString*)makeAndGetSnapName:(CSPlayModel*)playModel;

- (void)playClound:(WMVL_PTZControlInfo)ptz playModel:(CSPlayModel*)playModel;

- (int)startRecord:(BOOL)bStart playModel:(CSPlayModel*)playModel;

- (void)openVoice:(BOOL)bIsOpen playModel:(CSPlayModel*)playModel;

- (void)changePasswordOld:(NSString*)oldPassword newPassword:(NSString*)newPassword success:(void (^)())success failure:(void (^)())failure;

- (void)alarmSearch:(WMVL_HistoryEventSearchCondition) searchCondition success:(void (^)())success failure:(void (^)())failure;

- (int)stopVoiceTalk:(CSPlayModel*)playModel;

- (int)startVoiceTalk:(CSPlayModel*)playModel;
@end
