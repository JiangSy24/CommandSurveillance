#pragma once

#ifdef _ANDROID
#include <jni.h>
#endif

#include "commonplatform_types.h"

#define WM_AUTHENTICATE_MAX_IP_LEN (128)

#define WM_AUTHENTICATE_MAX_USERNAME_LEN (64)
#define WM_AUTHENTICATE_MAX_PASSWORD_LEN (64)

#define WM_AUTHENTICATE_MAX_SIGNATURE_LEN (128)
#define WM_AUTHENTICATE_MAX_SYSCONF_LEN (512)

#define WM_AUTHENTICATE_DEFAULT_LOGLEVEL (63)

#define WM_AUTHENTICATE_MAX_PATH_LEN (512)
#define WM_AUTHENTICATE_CODEQUEUE_CHANNELSIZE (1*1024*1024)

#define WM_AUTHENTICATE_DESKEY_LEN (64)

#define WM_AUTHENTICATE_MAX_USERMARK_LEN (64)
#define WM_AUTHENTICATE_MAX_CHECKKEY_LEN (64) 

#ifdef WIN32 
#define __PRETTY_FUNCTION__  __FUNCTION__ 
#endif

//错误码
typedef enum enmWM_Authenticate_ErrorCode
{
	WM_Authenticate_ErrorCode_Fail = 10001,							//未知错误
	WM_Authenticate_ErrorCode_WaitResult = 10002,					//异步等待结果
	WM_Authenticate_ErrorCode_InvalidParameter = 10003,				//无效参数
	WM_Authenticate_ErrorCode_SdkInitFail = 10004,					//Sdk初始化失败
	WM_Authenticate_ErrorCode_HasInit = 10005,						//Sdk已经初始化
	WM_Authenticate_ErrorCode_NoInit = 10006,						//Sdk未初始化
	WM_Authenticate_ErrorCode_ConnectFail = 10007,					//连接失败
	WM_Authenticate_ErrorCode_ResponseTimeout = 10008,				//超时
	WM_Authenticate_ErrorCode_HasLogin = 10009,						//已经登录
	WM_Authenticate_ErrorCode_NoLogin = 10010,						//没有登录
	WM_Authenticate_ErrorCode_NoExistUserName = 10011,				//用户名不存在
	WM_Authenticate_ErrorCode_ErrorPassword = 10012,				//密码错误
	WM_Authenticate_ErrorCode_ServerReject = 10013,					//服务器拒绝
	WM_Authenticate_ErrorCode_InvalidSignature = 10014,				//无效签名
	WM_Authenticate_ErrorCode_NoVerifyCode = 10015,					//验证码无效
	WM_Authenticate_ErrorCode_VerifCodeError = 10016,				//验证码错误
	WM_Authenticate_ErrorCode_InvalidVerifyCode = 10017,			//验证码过期
}WM_Authenticate_ErrorCode;

//基本消息ID
typedef enum enmWMAuthenticateSvrMsgId
{
	WM_Authenticate_SvrMsgId_DisConnect = 1,					//断线通知
	WM_Authenticate_SvrMsgId_ReConnect,							//重连通知
	WM_Authenticate_SvrMsgId_KickOut,							//被服务器踢通知, 
	WM_Authenticate_SvrMsgId_UpdateSignature,					//更新签名
}WMAuthenticateSvrMsgId;

typedef enum enmWMAuthClientType
{
	WMAuthClientType_PC = 1,
	WMAuthClientType_Android,
	WMAuthClientType_Ios,
}WMAuthClientType;

//定时器标识
typedef enum enmWMAuthTimerMark
{
	WMAuthTimerMark_SayHello = 1,
	WMAuthTimerMark_CheckActivate,
}WMAuthTimerMark;

//定时器时间间隔
typedef enum enmWMAuthTimerInterval
{
	WMAuthTimerInterval_SayHello = 3,	//s
	WMAuthTimerInterval_CheckActivate = 8,	//s
	WMAuthTimerInterval_RebuildSignature = (60*4),	//s
	WMAuthTimerInterval_ValidSignature = (60*5),	//s
}WMAuthTimerInterval;

typedef enum enmWMAuthenticateType
{
	WMAuthenticateType_Invalid = 0,
	WMAuthenticateType_Password,
	WMAuthenticateType_VerifyCode,
	WMAuthenticateType_Reconnect,
}WMAuthenticateType;

//基本消息回调
typedef void (*fWMAuthenticateSvrMsgCallBack)(int32_t nMsgId, uint32_t nResultCode, void* pUser);

//初始化客户端SDK配置信息
typedef struct stWM_Authenticate_EnvCfg
{
	int32_t m_nLogLevel;

	char m_szSvrIp[WM_AUTHENTICATE_MAX_IP_LEN];
	uint16_t m_nPort;

	fWMAuthenticateSvrMsgCallBack m_callbackFunc;
#ifdef _ANDROID
	jobject m_objCallBack;
#endif	
	
}WM_Authenticate_EnvCfg;

//初始化服务端SDK配置信息
typedef struct stWM_AuthenticateSvr_EnvCfg
{
	int32_t m_nLogLevel;

	char m_szSvrIp[WM_AUTHENTICATE_MAX_IP_LEN];
	uint16_t m_nPort;

	char m_szSignatureKey[WM_AUTHENTICATE_DESKEY_LEN];
	char m_szSysConf[WM_AUTHENTICATE_MAX_SYSCONF_LEN];
}WM_AuthenticateSvr_EnvCfg;

//认证请求参数
typedef struct stWMAuthParameters
{	
	int8_t m_nAuthType;

	char m_szUserMark[WM_AUTHENTICATE_MAX_USERMARK_LEN];
	char m_szCheckKey[WM_AUTHENTICATE_MAX_CHECKKEY_LEN];
}WMAuthParameters;

//认证服务器事件
//class IClientAuthEvent
//{
//public:    
//    virtual void OnClientLogin(char* szUserMark, char* szCheckKey, int8_t nAuthType, uint32_t nConnIdx, int32_t* pLoginResult) = 0;
//    virtual void OnLogout(uint32_t nConnIdx) = 0;
//
//    virtual void OnClientDisconnect(uint32_t nConnIdx) = 0;
//    virtual void OnUpdateSignature(uint32_t nConnIdx, const char* pszSignature, int32_t nSignatureLen) = 0;
//};
