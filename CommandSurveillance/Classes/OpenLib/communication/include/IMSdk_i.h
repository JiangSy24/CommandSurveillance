#pragma once

#include "commonplatform_types.h"

#define WM_IM_INVALID_GROUP_ID (-1) //无效的组ID
#define WM_IM_INVALID_CALL_ID (0)   //无效的通话ID

#define WM_IM_MAX_IP_LEN (128)
#define WM_IM_MAX_PATH_LEN (256)
#define WM_IM_DEFAULT_LOGLEVEL (63)

#define WM_IM_MAX_SIGNATURE_LEN (64)

#define WM_IM_MAX_CHAT_CONTENT_LEN (30*1024)   //聊天内容最大长度
#define WM_IM_MAX_ADDRESS_LEN (1024)           //地址最大长度

#define WM_IM_MAX_CHAT_MSG_JSON_LEN (WM_IM_MAX_CHAT_CONTENT_LEN + 1024)  //聊天信息的json串长度
#define WM_IM_MAX_LOCATION_JSON_LEN (WM_IM_MAX_ADDRESS_LEN + WM_IM_MAX_CHAT_CONTENT_LEN + 1024)  //位置信息的json串长度
#define WM_IM_GROUP_IDS_LEN (13*1024)

#define __PRETTY_FUNCTION__  __FUNCTION__ 

//错误码
typedef enum enmWM_IM_ErrorCode
{
	WM_IM_ErrorCode_ConnectFail = 2,    //连接失败
	WM_IM_ErrorCode_PlatformHasInit,	//重复初始化
	WM_IM_ErrorCode_PlatformNoInit,		//没有初始化
	WM_IM_ErrorCode_ResponseTimeout,	//超时
	WM_IM_ErrorCode_HasLogin,
	WM_IM_ErrorCode_NoLogin,
	WM_IM_ErrorCode_InvalidParameter,
	WM_IM_ErrorCode_SDKCallInitFail,
	WM_IM_ErrorCode_RegisterFail,
	WM_IM_ErrorCode_HasRegister,
	WM_IM_ErrorCode_NotFindUser,         //未找到该用户
	WM_IM_ErrorCode_DB_WRITE_FAIL,
	WM_IM_ErrorCode_GroupNameExists,
	WM_IM_ErrorCode_NotFindGroup,       //没有找到该组
	WM_IM_ErrorCode_NoPermissions,      //权限不足
	WM_IM_ErrorCode_UserNotInGroup,     //该用户不再组中
	WM_IM_ErrorCode_PamError,           //参数错误
	WM_IM_ErrorCode_SysError,           //系统错误
	WM_IM_ErrorCode_NotFindCall,        //没有找到该会话
	WM_IM_ErrorCode_MicOccupy,          //mic被占用
	WM_IM_ErrorCode_MicNotOccupy,       //mic没被占用
	WM_IM_ErrorCode_MicNoPermissions,   //mic权限不足
	WM_IM_ErrorCode_WaitResult,         //等待结果
	WM_IM_ErrorCode_HasInGroup,         //已经在组里
	WM_IM_ErrorCode_IsCalling,          //已在通话
	WM_IM_ErrorCode_UserNotInCall,
}WM_IM_ErrorCode;

//基本消息ID
enum enmSvrMsgId
{
	WM_IM_SvrMsgId_Invalid = 0,
	WM_IM_SvrMsgId_UserOnline, //上线通知, {"userid": , "signature": "", "maccode": "", "clienttype": , "longitude":"", "latitude":"", "time": , "address":"", "content":""}
	WM_IM_SvrMsgId_UserOffline,//离线通知, {"userid"}
	WM_IM_SvrMsgId_DisConnect,//断线通知
	WM_IM_SvrMsgId_ReConnect,//重连通知, {"result", "syncuser":[{"id":, "maccode":"", "longitude":"", "latitude":"", "time": , "address":"", "content":""},...], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}],...}
	WM_IM_SvrMsgId_KickOut,//被服务器踢通知, 
	WM_IM_SvrMsgId_LocationInfo, //实时位置信息{"id":, "longitude":"", "latitude":"", "time": , "address":"", "content":""}
};

//群组消息ID
enum enmGroupMsgId
{
	WM_IM_GroupMsgId_Invalid = 0,
	WM_IM_GroupMsgId_Join_Notify, //添加组通知(自己被邀请入群), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
	WM_IM_GroupMsgId_Other_Join_Notify, //其他人加群通知, {"sponsorid", "groupid", "joinids":[{"id"}]}
	WM_IM_GroupMsgId_KickOut_Notify,  //被踢通知(自己), {"sponsorid", "groupid"}
	WM_IM_GroupMsgId_Other_KickOut_Notify, //被踢通知(其他), {"sponsorid", "groupid", "kickoutid"}
	WM_IM_GroupMsgId_HadLeft_Notify, //退群通知, {"groupid", "userid"}
	WM_IM_GroupMsgId_Dissolve_Notify, //解散通知, {"sponsorid", "groupid"}
};

//通话消息ID
enum enmCallMsgId
{
	WM_IM_CallMsgId_Invalid = 0,
	WM_IM_CallMsgId_Invite_Notify,  //邀请通知, {"chatid", "sponsorid", "chattype"}
	WM_IM_CallMsgId_Invite_Response, //邀请回应，{"chatid", "userid", "response"}
	WM_IM_CallMsgId_MemAdd_Notify,  //成员增加通知, {"chatid", "sponsorid", "userid"}
	WM_IM_CallMsgId_MemLost_Notify,  //成员减少通知, {"chatid", "userid"}
	WM_IM_CallMsgId_CancelInvite_Notify, //取消邀请通知, {"chatid"}
	WM_IM_CallMsgId_RobMic_Notify, //抢麦通知, {"chatid", "userid", "time"}
	WM_IM_CallMsgId_FreeMic_Notify, //放麦通知, {"chatid", "userid", "time"} 
	WM_IM_CallMsgId_KickOutSelf_Notify, //自己被踢通知{"chatid", "sponsorid"}
	WM_IM_CallMsgId_KickOutOther_Notify, //其他成员被踢通知{"chatid", "sponsorid", "userid"}
};

//会议类型
typedef enum enmWM_IM_CallType
{
	WM_IM_CallType_Invalid = -1,
	WM_IM_CallType_Voice_RobMic = 0, //语言抢麦模式
	WM_IM_CallType_Voice = 1,            //正常语音模式
	WM_IM_CallType_Video_RobMic = 2, //视频抢麦模式
	WM_IM_CallType_Video = 3,            //正常视频模式
	WM_IM_CallType_Single_Voice_RobMic = 4,    //单人语言抢麦模式
	WM_IM_CallType_Single_Voice = 5,           //单人正常语音模式
	WM_IM_CallType_Single_Video_RobMic = 6,    //单人视频抢麦模式
	WM_IM_CallType_Single_Video = 7,           //单人正常视频模式
	WM_IM_CallType_Group_Voice_RobMic = 8,    //群组语言抢麦模式
	WM_IM_CallType_Group_Voice = 9,           //群组正常语音模式
	WM_IM_CallType_Group_Video_RobMic = 10,    //群组视频抢麦模式
	WM_IM_CallType_Group_Video = 11,           //群组正常视频模式
	WM_IM_CallType_Group_Conference = 12,      //群组会议模式
	WM_IM_CallType_Group_Voice_Force = 13,           //群组语音强拉模式
}WM_IM_CallType;

//聊天消息ID
enum enmChatMsgTypeId
{
	WM_IM_ChatMsgTypeId_Invalid = 0,
	WM_IM_ChatMsgTypeId_Single,  //单人聊天消息{"content" : "456", "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
	WM_IM_ChatMsgTypeId_Group,  //群组聊天消息 {"content" : "456", "groupid" : 39, "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
};

/**********************************************************************************************
回调函数定义
***********************************************************************************************/

//基本消息回调
typedef void (*fWMSvrMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//群组消息回调
typedef void (*fWMGroupMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//登录结果回调 
//pMsgData为注册结果,格式为:
/*{"result": , 
	"syncuser":[{"id":, "maccode":"", "clienttype":,"longitude":"", "latitude":"", "time": , "address":"", "content":""},...], 
	"syncgroup":[{"id": , "name":"", "owner":"", "createtime":"", "reserved1":, "reserved2":, "reserved3":, "reserved4":, "member":[{"id":}]},...]
  }

	syncuser : 在线用户列表
		syncuser[id] : 用户ID
		syncuser[maccode] : 用户机器码
		syncuser[clienttype] : 登录类型 0-PC 1-移动端
		syncuser[longitude] : 位置坐标
		syncuser[latitude] : 位置坐标
		syncuser[time] : 登录时间
		syncuser[address] : 地址
		syncuser[content] : 
				
	syncgroup ：组列表
		syncgroup[id] : 组ID
		syncgroup[name] : 组名称
		syncgroup[owner] : 创建者
		syncgroup[createtime] : 创建时间
		syncgroup[member] : 组成员
*/
typedef void (*fWMRegisterMsgCallBack)(const char* pMsgData, int32_t nDataLen, void* pUser);

//通话消息回调
typedef void (*fWMCallMsgCallBack)(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

//聊天消息回调
/*
* nMsgTypeId:聊天消息类型id
* nChatMsgId:聊天消息id(同种消息类型的唯一标识)
* pMsgData:聊天消息内容
*/
typedef void (*fWMChatMsgCallBack)(int32_t nMsgTypeId, int32_t nChatMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);


/**********************************************************************************************
结构体定义
***********************************************************************************************/

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

	int32_t m_nSayHelloTime; //心跳时间
}WM_IM_EnvConfigure;
