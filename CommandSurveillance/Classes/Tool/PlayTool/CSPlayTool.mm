////
////  CSPlayTool.m
////  CloudSurveillance
////
////  Created by liangcong on 16/9/2.
////  Copyright © 2016年 liangcong. All rights reserved.
////
//
#import "CSPlayTool.h"
#import "PlatformSdk_i.h"
#import "VLinkerSdk.h"
#import "VSErrView.h"
//#import <VomontCollection/VomontCollection.h>
@implementation CSAlarmImageModel
@end

@implementation CSAlarmVedioModel
@end

@implementation CSAlarmModel
- (NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

- (NSMutableArray *)vedioArr{
    if (_vedioArr == nil) {
        _vedioArr = [NSMutableArray array];
    }
    return _vedioArr;
}

@end

@implementation CSWifiModel
@end

@implementation CSPlayModel

@end

@interface CSPlayTool ()

@property (copy, nonatomic) void (^fWM_VL_StartRealPlayResultCallBack)(int32_t nResult, uint16_t m_nRealStreamHandle, const void *pUserData);

//@property (nonatomic,strong) VMAacPlayer    *playerAac;
@property (nonatomic, strong) NSMutableArray<CSPlayModel*>* arrayPlayer;

@end

//设备状态回调
void WM_VL_ResourceStatusMsgCallBack(uint32_t nResourceId, int32_t nStatus, const void *pUserData){
    
    NSString *strParent = [[VSDataCache sharedInstance].dicMapOfResDic objectForKey:[NSString stringWithFormat:@"%d",nResourceId]];
    if (strParent != nil) {
        NSArray *array = [[VSDataCache sharedInstance].dicResDevDic objectForKey:strParent];
        for (VSResListModel *resModel in array) {
            if ((resModel.id == nResourceId) &&
                (resModel.status != nStatus)) {
                [[VSDataCache sharedInstance] changeGroupStatusInfo:nResourceId isAdd:nStatus];
                resModel.status = nStatus;
                [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticeDevStatus object:nil];
                break;
            }
        }
    }
    
}

void WMClientDevStatusMessage(uint32_t nDevId, bool bStatus, HANDLE dwUser){

}

/**
 *  播放回调
 *
 *  @param nResult             0是成功1失败
 *  @param m_nRealStreamHandle 播放句柄前任是playerId
 *  @param pUserData           透传
 */
void WM_VL_StartRealPlayResultCallBack(int32_t nResult, uint16_t m_nRealStreamHandle, WMVL_StreamPam* streamPam, const void *pUserData){
    NSLog(@"WM_VL_StartRealPlayResultCallBack nResult[%d] playerId[%d]",nResult,m_nRealStreamHandle);
    
    if (pUserData == nil) {
        return;
    }
    CSPlayModel* playModel = (__bridge CSPlayModel*)pUserData;
    
    if (!nResult) {
        if (playModel.playSuccess) {
            playModel.playSuccess();
        }
    }else{
        if (playModel.playFailure) {
            playModel.playFailure();
        }
    }
}

/**
 *  修改密码回调
 *
 *  @param nResult   0是成功1失败
 *  @param cbType    不知道
 *  @param pUserData 透传
 */
void WM_VL_GeneralResultCallBack(int32_t nResult, WMVL_ResultCBType cbType, const void *pUserData){
    if (!nResult) {
        // 成功
        if ([CSPlayTool instance].passwordSuccess) {
            [CSPlayTool instance].passwordSuccess();
        }
    }else{
        // 失败
        if ([CSPlayTool instance].passwordFail) {
            [CSPlayTool instance].passwordFail();
        }
    }
}

/**
 *  wifi探针回调
 *
 *  @param nDevId    设备id
 *  @param pBuf      数据
 *  @param nSize     字节数
 *  @param pUserData 透传
 */
void WM_VL_TransparentDataCallBack(uint32_t nDevId, uint8_t* pBuf, int32_t nSize, const void* pUserData){
    
    if (nil == pBuf) {
        return;
    }

    NSString *strBuf = [NSString stringWithFormat:@"%s", pBuf];
    NSArray *arrayTag = [strBuf componentsSeparatedByString:@"|"];
    if (arrayTag.count > 0) {

        CSWifiModel *model = [[CSWifiModel alloc] init];
        model.strMacCode = arrayTag[0];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSString stringWithFormat:@"HH:mm:ss"];
        model.strGetTime = [dateFormatter stringFromDate:[NSDate date]];
        for (VSDeviceInfo *dev in [VSDataCache sharedInstance].deviceInfos) {
            if (dev.devID == nDevId) {
                model.strDevName = dev.devName;
            }
        }

        [[CSPlayTool instance].arraytMacModel insertObject:model atIndex:0];

        if ([CSPlayTool instance].arraytMacModel.count >= 100) {
            [[CSPlayTool instance].arraytMacModel removeLastObject];
        }

        // 发通知让有ui的界面刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticeWifi object:nil];
    }
    
    NSLog(@"WM_VL_TransparentDataCallBack count [%ld] pBuf[%s]",[CSPlayTool instance].arraytMacModel.count,pBuf);
}

/**
 *  报警信息回调
 *
 *  @param pEventMsg 报警信息
 *  @param pUserData 透传
 */
void WM_VL_EventMsgCallBack(WMVL_EventMsgInfo* pEventMsg, const void *pUserData){
    
    if (nil == pEventMsg) {
        return;
    }
    
    CSAlarmModel *model = [[CSAlarmModel alloc] init];
    WMVL_EventMsgInfo info = *pEventMsg;
    // 一堆脏活
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.m_baseInfo.m_nEventTime];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    model.strGetTime = [dateFormatter stringFromDate:date];
    model.strDevName = [NSString stringWithUTF8String:info.m_baseInfo.m_szResName];
    model.strAlarmType = [CSStatusTool getWMEventType:info.m_baseInfo.m_nEventType];
    model.alarmType = info.m_baseInfo.m_nEventType;
    
    for (int i = 0; i < info.m_nImageCnt; i++) {
        CSAlarmImageModel *imageD = [[CSAlarmImageModel alloc] init];
        imageD.url = [NSString stringWithFormat:@"%s",info.m_images[i].m_szUrl];
        imageD.iCreateTime = info.m_images[i].m_nCreateTime;
        imageD.iResId = info.m_images[i].m_nResId;
        [model.imageArr addObject:imageD];
    }
    
    for (int i = 0; i < info.m_nVideoCnt; i++) {
        CSAlarmVedioModel *vedioD = [[CSAlarmVedioModel alloc] init];
        vedioD.url = [NSString stringWithFormat:@"%s",info.m_videos[i].m_szUrl];
        vedioD.iResId = info.m_videos[i].m_nResId;
        [model.vedioArr addObject:vedioD];
    }
    
    [[CSPlayTool instance].arraytAlarmModel insertObject:model atIndex:0];
    if ([CSPlayTool instance].arraytMacModel.count >= 100) {
        [[CSPlayTool instance].arraytMacModel removeLastObject];
    }
    
    NSLog(@"WM_VL_EventMsgCallBack count [%ld]",[CSPlayTool instance].arraytAlarmModel.count);

    [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticeAlarm object:nil];
}

/**
 *  搜索历史报警记录回调
 *
 *  @param nResult      结果,0-成功，其他失败
 *  @param nTotCnt      报警记录总数
 *  @param bEnd         是否结束
 *  @param nMsgCnt      报警记录个数
 *  @param pEventMsgArr 报警记录信息数组
 *  @param pUserData    APP的自定义用户数据，SDK只负责传回给回调函数，不做任何处理！
 */
void WM_VL_HistoryEventMsgSearchCallBack(int32_t nResult, uint16_t nTotCnt, uint8_t bEnd, uint16_t nMsgCnt, WMVL_EventMsgInfo* pEventMsgArr, const void *pUserData){
    if (!nResult) {
        // 成功
        if ([CSPlayTool instance].searchAlarmSuccess) {

            BOOL bIsFirst = [CSPlayTool instance].arraySearchAlarm.count == 0;
            for (int i = 0; i < nMsgCnt; i++) {
                CSAlarmModel *model = [[CSAlarmModel alloc] init];
                WMVL_EventMsgInfo &info = pEventMsgArr[i];
                // 一堆脏活
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:info.m_baseInfo.m_nEventTime];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy/MM/dd HH:mm:ss"];
                model.strGetTime = [dateFormatter stringFromDate:date];
                model.strDevName = [NSString stringWithUTF8String:info.m_baseInfo.m_szResName];
                model.strAlarmType = [CSStatusTool getWMEventType:info.m_baseInfo.m_nEventType];
                model.alarmType = info.m_baseInfo.m_nEventType;
                
                for (int i = 0; i < info.m_nImageCnt; i++) {
                    CSAlarmImageModel *imageD = [[CSAlarmImageModel alloc] init];
                    imageD.url = [NSString stringWithFormat:@"%s",info.m_images[i].m_szUrl];
                    imageD.iCreateTime = info.m_images[i].m_nCreateTime;
                    imageD.iResId = info.m_images[i].m_nResId;
                    [model.imageArr addObject:imageD];
                }
                
                for (int i = 0; i < info.m_nVideoCnt; i++) {
                    CSAlarmVedioModel *vedioD = [[CSAlarmVedioModel alloc] init];
                    vedioD.url = [NSString stringWithFormat:@"%s",info.m_videos[i].m_szUrl];
                    vedioD.iResId = info.m_videos[i].m_nResId;
                    [model.vedioArr addObject:vedioD];
                }
                
                [[CSPlayTool instance].arraySearchAlarm addObject:model];
            }
            
            if (bIsFirst) {
                [CSPlayTool instance].searchAlarmSuccess();
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticeSearchAlarm object:nil];
            }

        }
    }else{
        // 失败
        if ([CSPlayTool instance].searchAlarmFail) {
            [CSPlayTool instance].searchAlarmFail();
        }
    }
}

#define WMMaxDevCount       1000
@implementation CSPlayTool

- (NSMutableArray<CSAlarmModel*>*)arraytAlarmModel{
    if (_arraytAlarmModel == nil) {
        _arraytAlarmModel = [NSMutableArray array];
    }
    return _arraytAlarmModel;
}

- (NSMutableArray<CSWifiModel*>*)arraytMacModel{
    if (_arraytMacModel == nil) {
        _arraytMacModel = [NSMutableArray array];
    }
    return _arraytMacModel;
}

//- (VMAacPlayer*)playerAac{
//    if (_playerAac == nil) {
//        _playerAac = [[VMAacPlayer alloc] init];
//    }
//    return _playerAac;
//}

- (id)init{
    self = [super init];
    return self;
}

- (void)dealloc{
//    WM_Client_Uninit();
}

static bool bSet = NO;

+ (instancetype)instance
{
    static dispatch_once_t  onceToken;
    static CSPlayTool * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[CSPlayTool alloc] init];
    });
    return sSharedInstance;
}

- (NSMutableArray<CSAlarmModel*>*)arraySearchAlarm{
    if (nil == _arraySearchAlarm) {
        _arraySearchAlarm = [NSMutableArray array];
    }
    return _arraySearchAlarm;
}

- (void)LoginUser:(NSString*)userName pwd:(NSString*)pwd hudToView:(UIView*)hudview url:(CSUrlString*)url success:(void (^)())success failure:(void (^)())failure{

    __block int32_t ret;
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        WM_VLinker_Logout();
        ret = WM_VLinker_Login((char *)[userName UTF8String], (char *)[pwd UTF8String], (char *)[url.ip UTF8String], url.port);//208,134,150,136
        NSLog(@"~~~~~~~~~~~~fuck~~~~~~~~~~~WM_Client_Login[%d]~~~~~~",ret);

        /**
         *  这里注册一些登陆后其他功能的操作,wifi探针
         */
        WM_VLinker_SetTransparentDataCallBack(WM_VL_TransparentDataCallBack, nil);
        
        // 报警回调
        WM_VLinker_SetEventMsgCallBack(WM_VL_EventMsgCallBack, nil);
        
        WM_VLinker_RegisterResourceStatusCB(WM_VL_ResourceStatusMsgCallBack, nil);
        // IMPORTANT - Dispatch back to the main thread. Always access UI
        
        if (0 == ret) {
            
            [self saveDevInfo];
            
            if (success) {
                success();
            }
        }else{
            if (failure) {
                failure();
            }
        }

    });
}

- (void)changePasswordOld:(NSString*)oldPassword newPassword:(NSString*)newPassword success:(void (^)())success failure:(void (^)())failure{
    
    WM_VLinker_UpdatePassword((char *)oldPassword.UTF8String, (char *)newPassword.UTF8String,
                              WM_VL_GeneralResultCallBack,nil);

    if (success) {
        self.passwordSuccess = success;
    }
    
    if (failure) {
        self.passwordFail = failure;
    }
}

void WM_VL_GetResListResultCallBack(int32_t nResult, bool bFinish, const char* pResListBuf, const void *pUserData){
    
    if (nResult == 0) {
        if ([CSPlayTool instance].searchListSuccess) {
            [CSPlayTool instance].searchListSuccess(bFinish,pResListBuf,pUserData);
        }
    }else{
        if ([CSPlayTool instance].searchListFail) {
            [CSPlayTool instance].searchListFail();
        }
    }
    
}

- (NSArray<VSResListModel*> *)recvListFunDevParentId:(int)nParentId{
    __block bool bIsFinish = NO;
    
    __block NSArray<VSResListModel*> *modelArray = nil;
    WM_VLinker_GetResList(1, nParentId, WM_VL_GetResListResultCallBack, nil);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [CSPlayTool instance].searchListSuccess = ^(bool bFinish, const char* pResListBuf, const void *pUserData) {
        
        NSString *tem =[NSString stringWithUTF8String:pResListBuf];
        NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
        modelArray = [VSResListModel mj_objectArrayWithKeyValuesArray:stringData];
        bIsFinish = bFinish;
        NSLog(@"recvListFunDevParentId json[%@] nParentId[%d]",tem ,nParentId);
        if (bIsFinish) {
            // 发送信号量
            dispatch_semaphore_signal(semaphore);
        }
        
    };
    
    [CSPlayTool instance].searchListFail = ^(){
        NSLog(@"recvListFunDevParentId error nParentId[%d]",nParentId);
        // 发送信号量
        dispatch_semaphore_signal(semaphore);
    };
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    return modelArray;
}

- (stGroupInfo)recvListFunGroupParentId:(int)nParentId{
    
    __block bool bIsFinish = NO;
    
    __block NSArray<VSResListModel*> *modelArray = nil;
    WM_VLinker_GetResList(0, nParentId, WM_VL_GetResListResultCallBack, nil);
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [CSPlayTool instance].searchListSuccess = ^(bool bFinish, const char* pResListBuf, const void *pUserData) {
        
        NSString *tem =[NSString stringWithUTF8String:pResListBuf];
        NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
        modelArray = [VSResListModel mj_objectArrayWithKeyValuesArray:stringData];
        bIsFinish = bFinish;
        NSLog(@"recvListFunGroupParentId json[%@] nParentId[%d]",tem ,nParentId);
        if (bIsFinish) {
            // 发送信号量
            dispatch_semaphore_signal(semaphore);
        }
        
    };
    
    [CSPlayTool instance].searchListFail = ^(){
        NSLog(@"recvListFunGroupParentId error nParentId[%d]",nParentId);
        // 发送信号量
        dispatch_semaphore_signal(semaphore);
    };
    
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待
    
    if ((modelArray.count == 0) ||
        (modelArray == nil)) {
        NSLog(@"modelArray don't have infomation! parentId[%d]",nParentId);
        stGroupInfo stTem = {0,0};
        return stTem;
    }else{
        stGroupInfo stTemAll = {0,0};
        for (int i = 0; i < modelArray.count; i++) {
            VSResListModel *model = modelArray[i];
            model.bIsGroup = YES;
            NSLog(@"send rec id[%d]",model.id);
            stGroupInfo stTem = [self recvListFunGroupParentId:model.id];
            model.iAllOnlineCount += stTem.iAllOnline;
            NSArray<VSResListModel*> *devArray = [self recvListFunDevParentId:model.id];
            for (int j = 0; j < devArray.count; j++) {
                VSResListModel *devmodel = devArray[j];
                stTemAll.iAllOnline = stTemAll.iAllOnline + stTem.iAllOnline + devmodel.status;
                model.iAllOnlineCount += devmodel.status;
                [[VSDataCache sharedInstance].dicMapOfResDic setObject:[NSString stringWithFormat:@"%d",devmodel.parentid] forKey:[NSString stringWithFormat:@"%d",devmodel.id]];
                devmodel.bIsGroup = NO;
            }
            stTemAll.iAllDevCount = stTemAll.iAllDevCount + stTem.iAllDevCount + devArray.count;
            model.iAllDevCount = stTem.iAllDevCount + devArray.count;
            NSLog(@"groupinfo id[%d] parentid[%d] allCount[%ld] allStauts[%ld]", model.id, model.parentid, model.iAllDevCount, model.iAllOnlineCount);
            // 存储设备
            // 存储
            if (devArray.count != 0) {
                [[VSDataCache sharedInstance] setDevDicFromArray:devArray parentid:model.id];
            }
            [[VSDataCache sharedInstance].dicMapOfResDic setObject:[NSString stringWithFormat:@"%d",model.parentid] forKey:[NSString stringWithFormat:@"%d",model.id]];
        }
        
        [[VSDataCache sharedInstance] setGroupDicFromArray:modelArray parentid:nParentId];
        return stTemAll;
    }
}

- (void)saveDevInfo{

    [self recvListFunGroupParentId:0];
    NSArray<VSResListModel*> *devArray = [self recvListFunDevParentId:0];
    [[VSDataCache sharedInstance] setDevDicFromArray:devArray parentid:0];
}

- (int)startVoiceTalk:(CSPlayModel*)playModel{
    int iRet = 1; // 1是失败
    if (playModel.playerId != WMPLAYERID_INVALID) {
        iRet = WM_VLinker_OpenSound(playModel.displayHandle);
    }
    return iRet;
}

- (int)stopVoiceTalk:(CSPlayModel*)playModel{
    int iRet = 1;// 1是失败
    if (playModel.playerId != WMPLAYERID_INVALID) {
        iRet = WM_VLinker_CloseSound(playModel.displayHandle);
    }
    return iRet;
}

- (void)openVoice:(BOOL)bIsOpen playModel:(CSPlayModel*)playModel{

    if (playModel.playerId == WMPLAYERID_INVALID) {
        return;
    }
    
    if (bIsOpen) {
        WM_VLinker_OpenSound(playModel.displayHandle);
    }else{
        WM_VLinker_CloseSound(playModel.displayHandle);
    }
}

- (void)stopPlay:(CSPlayModel*)playModel{

    if (playModel.playerId == WMPLAYERID_INVALID) {
        return;
    }
    int32_t ret = WM_VLinker_StopRealPlay(playModel.playerId);
    NSLog(@"fuck [WM_Client_StopRealPlay] playerid[%d] resid[%d] ret=%d",playModel.playerId,playModel.iResId,ret);
    playModel.playerId = WMPLAYERID_INVALID;

    [self destoryPlayer:playModel];
    NSLog(@"destoryPlayer  end");
}

- (void)destoryPlayer:(CSPlayModel*)playModel{

    if (playModel.displayHandle) {
        WM_VLinker_DestoryPlayer(playModel.displayHandle);
        playModel.displayHandle = nil;
    }
}

- (void)startPlayEx:(CSPlayModel*)playModel success:(void (^)())success failure:(void (^)())failure{
    
    if (playModel == nil) {
        return;
    }

    playModel.playerId = WMPLAYERID_INVALID;
    if (nil == playModel.displayHandle) {
        playModel.displayHandle = WM_VLinker_CreateStreamPlayer((__bridge HANDLE)playModel.displayView);
    }
    
    __block int32_t ret = 0;
    __block uint16_t playerID = 0;
    __block int iQuualityBlock = playModel.iQuality;

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        playerID = WMPLAYERID_INVALID;
        self.fWM_VL_StartRealPlayResultCallBack = ^(int32_t nResult, uint16_t m_nRealStreamHandle, const void *pUserData){
            
        };
        ret = WM_VLinker_StartRealPlay(playModel.iResId, playModel.iQuality, playModel.displayHandle, playerID, WM_VL_StartRealPlayResultCallBack, (__bridge void*)playModel);
        
        NSLog(@"%s : WM_Client_StartRealPlay, ret %d, playerID[%d]", __func__, ret, playerID);
        
        playModel.playerId = playerID;
        if (success) {
            playModel.playSuccess = success;
        }
        
        if (failure) {
            playModel.playFailure = failure;
        }

        if (0 != ret) {
            if (failure) {
                failure();
            }
        }
        
    });
    
}

- (int)makeSnapEx:(CSPlayModel*)playModel rootPath:(NSString*)strPath snapName:(NSString*)snapName{
    if(playModel.playerId == WMPLAYERID_INVALID)
    {
        return 1;
    }
    
    // pic_useid_工厂id_厂区id_设备id_时间
    NSString *path = [NSString stringWithFormat:@"%@/%@", strPath, snapName];//Documents,Library,tmp
    NSLog(@"path : %@", path);
    
    int32_t ret = WM_VLinker_RealPlaySnapshot(playModel.displayHandle, (char *)[path UTF8String]);
    NSLog(@"%s : ret %d _playerID:%d", __func__, ret, playModel.playerId);
    
    if (0 == ret) {
        // 发个通知 告诉有截图发生了，赶紧更新ui baby们
    }
    
    return ret;
}

- (int)makeSnap:(CSPlayModel*)playModel rootPath:(NSString*)strPath{
    if(playModel.playerId == WMPLAYERID_INVALID)
    {
        return 1;
    }

    // pic_useid_工厂id_厂区id_设备id_时间
    NSString *name = [NSString stringWithFormat:@"%@_%d_wm", _snapName,(int)[[NSDate date] timeIntervalSince1970]];
    NSString *path = [NSString stringWithFormat:@"%@/%@", strPath, name];//Documents,Library,tmp
    NSLog(@"path : %@", path);
    
    int32_t ret = WM_VLinker_RealPlaySnapshot(playModel.displayHandle, (char *)[path UTF8String]);
    NSLog(@"%s : ret %d _playerID:%d", __func__, ret, playModel.playerId);
    
    if (0 == ret) {
        // 发个通知 告诉有截图发生了，赶紧更新ui baby们
        [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticePicture object:nil];
    }
    
    return ret;
}

- (NSString*)makeAndGetSnapName:(CSPlayModel*)playModel{
    if(playModel.playerId == WMPLAYERID_INVALID)
    {
        return nil;
    }
    
    // pic_useid_工厂id_厂区id_设备id_时间
    NSString *name = [NSString stringWithFormat:@"%@_%d_wm", _snapName,(int)[[NSDate date] timeIntervalSince1970]];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/FileDoc/%@", NSHomeDirectory(), name];//Documents,Library,tmp
    NSLog(@"path : %@", path);
    
    int32_t ret = WM_VLinker_RealPlaySnapshot(playModel.displayHandle, (char *)[path UTF8String]);
    NSLog(@"%s : ret %d _playerID:%d", __func__, ret, playModel.playerId);
    
    if (0 == ret) {
        // 发个通知 告诉有截图发生了，赶紧更新ui baby们
        //        [[NSNotificationCenter defaultCenter] postNotificationName:CSNoticePicture object:nil];
    }
    
    return [path stringByAppendingString:@".jpg"];
}

// 云台播放
- (void)playClound:(WMVL_PTZControlInfo)ptz playModel:(CSPlayModel*)playModel{
    if ((nil == playModel)||
        (playModel.playerId == WMPLAYERID_INVALID)) {
        return;
    }
    
    int iret = WM_VLinker_PTZControl(playModel.iResId, ptz);
    NSLog(@"ret WM_Client_PTZControl %d",iret);
    if (!iret) {
        //success
    }
}

- (int)startRecord:(BOOL)bStart playModel:(CSPlayModel*)playModel{
    int iRet = 0;
    NSString *name = [NSString stringWithFormat:@"%@_%d_wm", _snapName,(int)[[NSDate date] timeIntervalSince1970]];
    NSString *video = SnapPath;
    NSString *path = [NSString stringWithFormat:@"%@/%@", video, name];//Documents,Library,tmp

    if (bStart) {
        iRet = WM_VLinker_StartRecordEx(playModel.displayHandle, (char*)[path UTF8String]);
    }else{
        iRet = WM_VLinker_StopRecordEx(playModel.displayHandle);
    }
    return iRet;
}

- (void)alarmSearch:(WMVL_HistoryEventSearchCondition) searchCondition success:(void (^)())success failure:(void (^)())failure{
    
    [[CSPlayTool instance].arraySearchAlarm removeAllObjects];
    
    if (success) {
        self.searchAlarmSuccess = success;
    }
    
    if (failure) {
        self.searchAlarmFail = failure;
    }
    
    int ret = WM_VLinker_HistoryEventMsgSearch(searchCondition, WM_VL_HistoryEventMsgSearchCallBack,nil);
    if (0 != ret) {
        if (failure) {
            failure();
        }
    }
}

@end
