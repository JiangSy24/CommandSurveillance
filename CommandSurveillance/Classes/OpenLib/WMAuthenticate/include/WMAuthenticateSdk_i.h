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

//������
typedef enum enmWM_Authenticate_ErrorCode
{
	WM_Authenticate_ErrorCode_Fail = 10001,							//δ֪����
	WM_Authenticate_ErrorCode_WaitResult = 10002,					//�첽�ȴ����
	WM_Authenticate_ErrorCode_InvalidParameter = 10003,				//��Ч����
	WM_Authenticate_ErrorCode_SdkInitFail = 10004,					//Sdk��ʼ��ʧ��
	WM_Authenticate_ErrorCode_HasInit = 10005,						//Sdk�Ѿ���ʼ��
	WM_Authenticate_ErrorCode_NoInit = 10006,						//Sdkδ��ʼ��
	WM_Authenticate_ErrorCode_ConnectFail = 10007,					//����ʧ��
	WM_Authenticate_ErrorCode_ResponseTimeout = 10008,				//��ʱ
	WM_Authenticate_ErrorCode_HasLogin = 10009,						//�Ѿ���¼
	WM_Authenticate_ErrorCode_NoLogin = 10010,						//û�е�¼
	WM_Authenticate_ErrorCode_NoExistUserName = 10011,				//�û���������
	WM_Authenticate_ErrorCode_ErrorPassword = 10012,				//�������
	WM_Authenticate_ErrorCode_ServerReject = 10013,					//�������ܾ�
	WM_Authenticate_ErrorCode_InvalidSignature = 10014,				//��Чǩ��
	WM_Authenticate_ErrorCode_NoVerifyCode = 10015,					//��֤����Ч
	WM_Authenticate_ErrorCode_VerifCodeError = 10016,				//��֤�����
	WM_Authenticate_ErrorCode_InvalidVerifyCode = 10017,			//��֤�����
}WM_Authenticate_ErrorCode;

//������ϢID
typedef enum enmWMAuthenticateSvrMsgId
{
	WM_Authenticate_SvrMsgId_DisConnect = 1,					//����֪ͨ
	WM_Authenticate_SvrMsgId_ReConnect,							//����֪ͨ
	WM_Authenticate_SvrMsgId_KickOut,							//����������֪ͨ, 
	WM_Authenticate_SvrMsgId_UpdateSignature,					//����ǩ��
}WMAuthenticateSvrMsgId;

typedef enum enmWMAuthClientType
{
	WMAuthClientType_PC = 1,
	WMAuthClientType_Android,
	WMAuthClientType_Ios,
}WMAuthClientType;

//��ʱ����ʶ
typedef enum enmWMAuthTimerMark
{
	WMAuthTimerMark_SayHello = 1,
	WMAuthTimerMark_CheckActivate,
}WMAuthTimerMark;

//��ʱ��ʱ����
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

//������Ϣ�ص�
typedef void (*fWMAuthenticateSvrMsgCallBack)(int32_t nMsgId, uint32_t nResultCode, void* pUser);

//��ʼ���ͻ���SDK������Ϣ
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

//��ʼ�������SDK������Ϣ
typedef struct stWM_AuthenticateSvr_EnvCfg
{
	int32_t m_nLogLevel;

	char m_szSvrIp[WM_AUTHENTICATE_MAX_IP_LEN];
	uint16_t m_nPort;

	char m_szSignatureKey[WM_AUTHENTICATE_DESKEY_LEN];
	char m_szSysConf[WM_AUTHENTICATE_MAX_SYSCONF_LEN];
}WM_AuthenticateSvr_EnvCfg;

//��֤�������
typedef struct stWMAuthParameters
{	
	int8_t m_nAuthType;

	char m_szUserMark[WM_AUTHENTICATE_MAX_USERMARK_LEN];
	char m_szCheckKey[WM_AUTHENTICATE_MAX_CHECKKEY_LEN];
}WMAuthParameters;

//��֤�������¼�
//class IClientAuthEvent
//{
//public:    
//    virtual void OnClientLogin(char* szUserMark, char* szCheckKey, int8_t nAuthType, uint32_t nConnIdx, int32_t* pLoginResult) = 0;
//    virtual void OnLogout(uint32_t nConnIdx) = 0;
//
//    virtual void OnClientDisconnect(uint32_t nConnIdx) = 0;
//    virtual void OnUpdateSignature(uint32_t nConnIdx, const char* pszSignature, int32_t nSignatureLen) = 0;
//};
