//
//  IMChatManageTool.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/29.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "IMChatManageTool.h"
#import "IMSdk.h"
#import "LMPhoneActModel.h"
#import "LMRegisterSyncuserModel.h"
#import "LMRegisterModle.h"
#import "IMChatManageToolAct.h"
#import "IMChatMsgDataManage.h"
#import "IMChatCallManage.h"
#import "IMTeamManage.h"

static int m_iRegisterResult = 1;//1是失败
void deallWithOnlineInfo(NSString* tem);
//基本消息回调
void WMSvrMsgCallBack(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser){

    if (pMsgData == nil) {
        return;
    }
    NSString *tem =[NSString stringWithUTF8String:pMsgData];
    NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
//    // 发消息搞
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 处理数据
        switch (nMsgId) {
            case WM_IM_SvrMsgId_UserOnline:
            {
                LMPhoneActModel *model = [LMPhoneActModel mj_objectWithKeyValues:stringData];
                // 上线
                LMRegisterSyncuserModel *temRe = [[LMRegisterSyncuserModel alloc] init];
                temRe.id = model.userid;
                temRe.signature = model.signature;
                temRe.maccode = model.maccode;
                
                [[LMRegisterModle instance].syncuserArry addObject:temRe];
                
                for (CSOneUserModel *temM  in [CSUsersModel instance].accounts) {
                    if (temM.id == temRe.id) {
                        temM.bIsOnline = YES;
                        break;
                    }
                }
                break;
            }
            case WM_IM_SvrMsgId_UserOffline:
            {
                // 离线
                LMPhoneActModel *model = [LMPhoneActModel mj_objectWithKeyValues:stringData];
                
                for (LMRegisterSyncuserModel *user in [LMRegisterModle instance].syncuserArry) {
                    if (user.id == model.userid) {
                        [[LMRegisterModle instance].syncuserArry removeObject:user];
                        break;
                    }
                }
                
                for (CSOneUserModel *tem  in [CSUsersModel instance].accounts) {
                    if (model.userid == tem.id) {
                        tem.bIsOnline = NO;
                        break;
                    }
                }
                break;
            }
            case WM_IM_SvrMsgId_DisConnect:
            {
                // 断线
                break;
            }
            case WM_IM_SvrMsgId_ReConnect:
            {
                // 重连
                deallWithOnlineInfo(tem);
                break;
            }
            case WM_IM_SvrMsgId_KickOut:
            {
                // 被服务器提出
                break;
            }
            default:
                break;
        }
        
        //    // 发消息搞
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticLoginReflash object:nil];
    });
}



//pMsgData为注册结果,格式为:
//{"result", "syncuser":[{"id", "maccode"}], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
void WMRegisterMsgCallBack(const char* pMsgData, int32_t nDataLen, void* pUser){
    printf("pMsgData %s",pMsgData);
    NSString *tem =[NSString stringWithUTF8String:pMsgData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        deallWithOnlineInfo(tem);
        [[NSNotificationCenter defaultCenter] postNotificationName:NoticLoginReflash object:nil];
    });
    
    NSLog(@"WMRegisterMsgCallBack %s",pMsgData);
}

void deallWithOnlineInfo(NSString* tem){
    
    [[LMRegisterModle instance].syncuserArry removeAllObjects];
    [[LMRegisterModle instance].syncgroupArry removeAllObjects];
    NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
    LMRegisterModle *model = [LMRegisterModle mj_objectWithKeyValues:stringData];
    [[LMRegisterModle instance].syncuserArry addObjectsFromArray:model.syncuser];
    [[LMRegisterModle instance].syncgroupArry addObjectsFromArray:model.syncgroup];
    
//    for (LMRegisterSyncgroupModel *temGro  in [LMRegisterModle instance].syncgroupArry) {
//        for (LMRegisterSyncgroupModel *mem in temGro.member) {
//            if ([CSUrlString instance].account.sysconf.accountid == mem.id) {
//                [temGro.member removeObject:mem];
//                break;
//            }
//        }
//    }
    
    for (CSOneUserModel *tem  in [CSUsersModel instance].accounts) {
        tem.bIsOnline = NO;
        for (LMRegisterSyncuserModel *model in [LMRegisterModle instance].syncuserArry) {
            if (model.id == tem.id) {
                tem.bIsOnline = YES;
                break;
            }
        }
    }
    
    m_iRegisterResult = model.result;
}



@interface IMChatManageTool()
@property (nonatomic,strong) Authenticate* authentModel;
@property (assign, nonatomic) int iIsRegiste;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic,strong) IMChatManageToolAct *chatIMManager;
@property (nonatomic,strong) IMChatMsgDataManage *dataManage;
@property (nonatomic,strong) IMChatCallManage *mycallManage;
@property (nonatomic,strong) IMTeamManage *teamManageTool;
@end

@implementation IMChatManageTool

- (id<WMIMTeamManageTool>)teamManage{
    return self.teamManageTool;
}

- (IMTeamManage*)teamManageTool{
    if (nil == _teamManageTool) {
        _teamManageTool = [[IMTeamManage alloc] init];
    }
    return _teamManageTool;
}

- (id<WMIMChatManageTool>)chatManager{
    return self.chatIMManager;
}

- (IMChatManageToolAct*)chatIMManager{
    if (nil == _chatIMManager) {
        _chatIMManager = [[IMChatManageToolAct alloc] init];
    }
    return _chatIMManager;
}

- (id<WMIMChatCallManage>)callManage{
    return self.mycallManage;
}

- (IMChatCallManage*)mycallManage{
    if (nil == _mycallManage) {
        _mycallManage = [[IMChatCallManage alloc] init];
    }
    return _mycallManage;
}

- (id<WMIMChatMsgData>)msgDataManage{
    if (nil == _dataManage) {
        _dataManage = [[IMChatMsgDataManage alloc] init];
    }
    return _dataManage;
}

- (void)dealloc{
    [[CSUrlString instance] uinitAuthenticate];
    WM_IM_Uninit();
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

// 数据操作类
+ (instancetype)instance
{
    //    static dispatch_once_t  onceToken;
    static IMChatManageTool* tool = nil;
    if (tool == nil) {
        tool = [[[self class] alloc] init];
    }
    return tool;
}

- (void)chatLoginUserName:(NSString*)strUserName passWord:(NSString*)strPassword ipAddress:(NSString*)address port:(int)port success:(void (^)(Authenticate* model))success failure:(void (^)(int error))failure{
    [[CSUrlString instance] uinitAuthenticate];
    if ([[CSUrlString instance] initAuthenticateIp:address port:port]) {
        if (failure) {
            failure(1);
        }
        return;
    }
    
    __block int iret = 1;
    iret = [[CSUrlString instance] Authenticate_LoginType:1 userName:strUserName passWord:strPassword];
    
    if (iret == 0) {
        [[CSUrlString instance] Authenticate_GetSysConfSuccess:^(Authenticate *model) {
            self.authentModel = model;
            [self loginWmIMsdk];
        } failure:^(int error) {
            iret = error;
        }];
        
        if ((success != nil)&&
            (iret == 0)) {
            success(self.authentModel);
        }
    }else{
        if (failure != nil) {
            failure(iret);
        }
    }
}

/*
 //初始化配置信息
 typedef struct stWM_IM_EnvConfigure
 {
 int32_t m_nLogLevel;
 char m_szSvrIp[WM_IM_MAX_IP_LEN];
 int32_t m_nPort;
 void* m_pSvrMsgUser;
 fWMSvrMsgCallBack m_svrMsgCB;
 void* m_pGroupMsgUser;
 fWMGroupMsgCallBack m_groupMsgCB;
 
 void* m_pChatMsgUser;
 fWMChatMsgCallBack m_chatMsgCB;
 }WM_IM_EnvConfigure;
 */

- (void)loginWmIMsdk{
    WM_IM_Uninit();
    WM_IM_EnvConfigure  stConfig;
    strcpy(stConfig.m_szSvrIp, self.authentModel.sysconf.imsvrip.UTF8String);
    stConfig.m_nPort = self.authentModel.sysconf.imsvrport;
    stConfig.m_pSvrMsgUser = nil;
    stConfig.m_svrMsgCB = &WMSvrMsgCallBack;
    stConfig.m_pGroupMsgUser = nil;
    stConfig.m_groupMsgCB = &WMGroupMsgCallBack;// 组群管理分不出去了，因为在这设计的
    stConfig.m_nLogLevel = 127;
    stConfig.m_chatMsgCB = &WMChatMsgCallBack;
    //
    WM_IM_Init(stConfig);
    WM_IM_UnRegister();
    //VEYE-
    NSString *strImMac = [NSString stringWithFormat:@"a_%@",[NSString getMacAddress]];
    self.iIsRegiste = WM_IM_Register(self.authentModel.sysconf.accountid, self.authentModel.sysconf.signature.UTF8String, strImMac.UTF8String, &WMRegisterMsgCallBack, nil);
    WM_IM_Chat_SetMsgCallBack(&WMChatMsgCallBack, nil);
    
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(registeOnline:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }

}

-(void)registeOnline:(NSTimer *)timer{
    if (self.iIsRegiste || (m_iRegisterResult != 0)) {
        WM_IM_UnRegister();
        self.iIsRegiste = WM_IM_Register(self.authentModel.sysconf.accountid, self.authentModel.sysconf.signature.UTF8String, [NSString getMacAddress].UTF8String, &WMRegisterMsgCallBack, nil);
    }else{

    }
}
@end
