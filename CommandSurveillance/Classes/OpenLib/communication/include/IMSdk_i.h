#pragma once

#include "commonplatform_types.h"

#define WM_IM_INVALID_GROUP_ID (-1) //��Ч����ID
#define WM_IM_INVALID_CALL_ID (0)   //��Ч��ͨ��ID

#define WM_IM_MAX_IP_LEN (128)
#define WM_IM_MAX_PATH_LEN (256)
#define WM_IM_DEFAULT_LOGLEVEL (63)

#define WM_IM_MAX_SIGNATURE_LEN (64)

#define WM_IM_MAX_CHAT_CONTENT_LEN (30*1024)   //����������󳤶�
#define WM_IM_MAX_ADDRESS_LEN (1024)           //��ַ��󳤶�

#define WM_IM_MAX_CHAT_MSG_JSON_LEN (WM_IM_MAX_CHAT_CONTENT_LEN + 1024)  //������Ϣ��json������
#define WM_IM_MAX_LOCATION_JSON_LEN (WM_IM_MAX_ADDRESS_LEN + WM_IM_MAX_CHAT_CONTENT_LEN + 1024)  //λ����Ϣ��json������
#define WM_IM_GROUP_IDS_LEN (13*1024)

#define __PRETTY_FUNCTION__  __FUNCTION__ 

//������
typedef enum enmWM_IM_ErrorCode
{
	WM_IM_ErrorCode_ConnectFail = 2,    //����ʧ��
	WM_IM_ErrorCode_PlatformHasInit,	//�ظ���ʼ��
	WM_IM_ErrorCode_PlatformNoInit,		//û�г�ʼ��
	WM_IM_ErrorCode_ResponseTimeout,	//��ʱ
	WM_IM_ErrorCode_HasLogin,
	WM_IM_ErrorCode_NoLogin,
	WM_IM_ErrorCode_InvalidParameter,
	WM_IM_ErrorCode_SDKCallInitFail,
	WM_IM_ErrorCode_RegisterFail,
	WM_IM_ErrorCode_HasRegister,
	WM_IM_ErrorCode_NotFindUser,         //δ�ҵ����û�
	WM_IM_ErrorCode_DB_WRITE_FAIL,
	WM_IM_ErrorCode_GroupNameExists,
	WM_IM_ErrorCode_NotFindGroup,       //û���ҵ�����
	WM_IM_ErrorCode_NoPermissions,      //Ȩ�޲���
	WM_IM_ErrorCode_UserNotInGroup,     //���û���������
	WM_IM_ErrorCode_PamError,           //��������
	WM_IM_ErrorCode_SysError,           //ϵͳ����
	WM_IM_ErrorCode_NotFindCall,        //û���ҵ��ûỰ
	WM_IM_ErrorCode_MicOccupy,          //mic��ռ��
	WM_IM_ErrorCode_MicNotOccupy,       //micû��ռ��
	WM_IM_ErrorCode_MicNoPermissions,   //micȨ�޲���
	WM_IM_ErrorCode_WaitResult,         //�ȴ����
	WM_IM_ErrorCode_HasInGroup,         //�Ѿ�������
	WM_IM_ErrorCode_IsCalling,          //����ͨ��
	WM_IM_ErrorCode_UserNotInCall,
}WM_IM_ErrorCode;

//������ϢID
enum enmSvrMsgId
{
	WM_IM_SvrMsgId_Invalid = 0,
	WM_IM_SvrMsgId_UserOnline, //����֪ͨ, {"userid": , "signature": "", "maccode": "", "clienttype": , "longitude":"", "latitude":"", "time": , "address":"", "content":""}
	WM_IM_SvrMsgId_UserOffline,//����֪ͨ, {"userid"}
	WM_IM_SvrMsgId_DisConnect,//����֪ͨ
	WM_IM_SvrMsgId_ReConnect,//����֪ͨ, {"result", "syncuser":[{"id":, "maccode":"", "longitude":"", "latitude":"", "time": , "address":"", "content":""},...], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}],...}
	WM_IM_SvrMsgId_KickOut,//����������֪ͨ, 
	WM_IM_SvrMsgId_LocationInfo, //ʵʱλ����Ϣ{"id":, "longitude":"", "latitude":"", "time": , "address":"", "content":""}
};

//Ⱥ����ϢID
enum enmGroupMsgId
{
	WM_IM_GroupMsgId_Invalid = 0,
	WM_IM_GroupMsgId_Join_Notify, //�����֪ͨ(�Լ���������Ⱥ), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
	WM_IM_GroupMsgId_Other_Join_Notify, //�����˼�Ⱥ֪ͨ, {"sponsorid", "groupid", "joinids":[{"id"}]}
	WM_IM_GroupMsgId_KickOut_Notify,  //����֪ͨ(�Լ�), {"sponsorid", "groupid"}
	WM_IM_GroupMsgId_Other_KickOut_Notify, //����֪ͨ(����), {"sponsorid", "groupid", "kickoutid"}
	WM_IM_GroupMsgId_HadLeft_Notify, //��Ⱥ֪ͨ, {"groupid", "userid"}
	WM_IM_GroupMsgId_Dissolve_Notify, //��ɢ֪ͨ, {"sponsorid", "groupid"}
};

//ͨ����ϢID
enum enmCallMsgId
{
	WM_IM_CallMsgId_Invalid = 0,
	WM_IM_CallMsgId_Invite_Notify,  //����֪ͨ, {"chatid", "sponsorid", "chattype"}
	WM_IM_CallMsgId_Invite_Response, //�����Ӧ��{"chatid", "userid", "response"}
	WM_IM_CallMsgId_MemAdd_Notify,  //��Ա����֪ͨ, {"chatid", "sponsorid", "userid"}
	WM_IM_CallMsgId_MemLost_Notify,  //��Ա����֪ͨ, {"chatid", "userid"}
	WM_IM_CallMsgId_CancelInvite_Notify, //ȡ������֪ͨ, {"chatid"}
	WM_IM_CallMsgId_RobMic_Notify, //����֪ͨ, {"chatid", "userid", "time"}
	WM_IM_CallMsgId_FreeMic_Notify, //����֪ͨ, {"chatid", "userid", "time"} 
	WM_IM_CallMsgId_KickOutSelf_Notify, //�Լ�����֪ͨ{"chatid", "sponsorid"}
	WM_IM_CallMsgId_KickOutOther_Notify, //������Ա����֪ͨ{"chatid", "sponsorid", "userid"}
};

//��������
typedef enum enmWM_IM_CallType
{
	WM_IM_CallType_Invalid = -1,
	WM_IM_CallType_Voice_RobMic = 0, //��������ģʽ
	WM_IM_CallType_Voice = 1,            //��������ģʽ
	WM_IM_CallType_Video_RobMic = 2, //��Ƶ����ģʽ
	WM_IM_CallType_Video = 3,            //������Ƶģʽ
	WM_IM_CallType_Single_Voice_RobMic = 4,    //������������ģʽ
	WM_IM_CallType_Single_Voice = 5,           //������������ģʽ
	WM_IM_CallType_Single_Video_RobMic = 6,    //������Ƶ����ģʽ
	WM_IM_CallType_Single_Video = 7,           //����������Ƶģʽ
	WM_IM_CallType_Group_Voice_RobMic = 8,    //Ⱥ����������ģʽ
	WM_IM_CallType_Group_Voice = 9,           //Ⱥ����������ģʽ
	WM_IM_CallType_Group_Video_RobMic = 10,    //Ⱥ����Ƶ����ģʽ
	WM_IM_CallType_Group_Video = 11,           //Ⱥ��������Ƶģʽ
	WM_IM_CallType_Group_Conference = 12,      //Ⱥ�����ģʽ
	WM_IM_CallType_Group_Voice_Force = 13,           //Ⱥ������ǿ��ģʽ
}WM_IM_CallType;

//������ϢID
enum enmChatMsgTypeId
{
	WM_IM_ChatMsgTypeId_Invalid = 0,
	WM_IM_ChatMsgTypeId_Single,  //����������Ϣ{"content" : "456", "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
	WM_IM_ChatMsgTypeId_Group,  //Ⱥ��������Ϣ {"content" : "456", "groupid" : 39, "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
};

/**********************************************************************************************
�ص���������
***********************************************************************************************/

//������Ϣ�ص�
typedef void (*fWMSvrMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//Ⱥ����Ϣ�ص�
typedef void (*fWMGroupMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//��¼����ص� 
//pMsgDataΪע����,��ʽΪ:
/*{"result": , 
	"syncuser":[{"id":, "maccode":"", "clienttype":,"longitude":"", "latitude":"", "time": , "address":"", "content":""},...], 
	"syncgroup":[{"id": , "name":"", "owner":"", "createtime":"", "reserved1":, "reserved2":, "reserved3":, "reserved4":, "member":[{"id":}]},...]
  }

	syncuser : �����û��б�
		syncuser[id] : �û�ID
		syncuser[maccode] : �û�������
		syncuser[clienttype] : ��¼���� 0-PC 1-�ƶ���
		syncuser[longitude] : λ������
		syncuser[latitude] : λ������
		syncuser[time] : ��¼ʱ��
		syncuser[address] : ��ַ
		syncuser[content] : 
				
	syncgroup �����б�
		syncgroup[id] : ��ID
		syncgroup[name] : ������
		syncgroup[owner] : ������
		syncgroup[createtime] : ����ʱ��
		syncgroup[member] : ���Ա
*/
typedef void (*fWMRegisterMsgCallBack)(const char* pMsgData, int32_t nDataLen, void* pUser);

//ͨ����Ϣ�ص�
typedef void (*fWMCallMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//������Ϣ�ص�
/*
* nMsgTypeId:������Ϣ����id
* nChatMsgId:������Ϣid(ͬ����Ϣ���͵�Ψһ��ʶ)
* pMsgData:������Ϣ����
*/
typedef void (*fWMChatMsgCallBack)(int32_t nMsgTypeId, int32_t nChatMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);


/**********************************************************************************************
�ṹ�嶨��
***********************************************************************************************/

//��ʼ��������Ϣ
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

	int32_t m_nSayHelloTime; //����ʱ��
}WM_IM_EnvConfigure;
