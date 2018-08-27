#pragma once

#include "IMSdk_i.h"

#ifdef WIN32
#ifdef IMSDK_EXPORTS
#define WM_IM_API extern "C" __declspec(dllexport)
#else
#define WM_IM_API extern "C" __declspec(dllimport)
#endif
#else
#define WM_IM_API	extern "C"
#endif


/********************************API 接口*******************************************/
/*
 * 功能：初始化，调用所有接口之前调用（日志的初始化、资源的申请）
 * 参数：
 *			envCfg		[IN]: 基本环境配置
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Init(WM_IM_EnvConfigure& envCfg);

/*
 * 功能：析构（释放Init申请的资源、日志的反初始化）
 * 参数：无
 * 返回值： 无
*/
WM_IM_API void WM_IM_Uninit();

/*
 * 功能：向服务器注册（异步）
 * 参数：
 *			nUserId			[IN]: 用户ID
 *			pszSignature	[IN]: 签名(长度待定)
 *			pszMacCode		[IN]: 机器码(长度待定)
 *			registerCB		[IN]:登录回调函数(回调信息包括：在线用户信息、群组信息)	
 *			pUser			[IN]:用户数据
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Register(uint32_t nUserId, const char* pszSignature, const char* pszMacCode, fWMRegisterMsgCallBack registerCB, void* pUser);

/*
 * 功能：注销
 * 参数：
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_UnRegister();

/*
 * 功能：创建群组（同步）
 * 参数：
 *			pGroupName	[IN]: 组信息
 * 返回值： -1-失败，其他作为组ID
*/
WM_IM_API int32_t WM_IM_GroupCreat(char* const pGroupName);

/*
 * 功能：添加成员（同步）
 * 参数：
 *			nGroupId	[IN]: 组ID
 *			pMemsJson	[IN]: 成员id列表 如{ "userids":["userid"]}
 * 返回值： 0-成功，其他失败
*/
WM_IM_API int32_t WM_IM_GroupInviteMember(int32_t nGroupId, const char* pMemsJson);

/*
 * 功能：踢人出群（同步）
 * 参数：
 *			nGroupId	[IN]: 组Id
 *			nUserId		[IN]: 被踢成员ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_GroupKickOut(int32_t nGroupId, int32_t nUserId);

/*
 * 功能：主动退群（同步）
 * 参数：
 *			nGroupId	[IN]: 组Id
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_GroupHadLeft(int32_t nGroupId);

/*
 * 功能：解散群组（同步）
 * 参数：
 *			nGroupId	[IN]: 组Id
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_GroupDissolve(int32_t nGroupId);

/*
 * 功能：设置通话消息回调
 * 参数：
 *			chatMsgCB	[IN]: 回调函数
 *			pUser		[IN]: 用户数据
 * 返回值： 0-成功，其他-失败
*/
WM_IM_API int32_t WM_IM_Chat_SetMsgCallBack(fWMCallMsgCallBack chatMsgCB, void* pUser);

/*
 * 功能：发起通话（同步）
 * 参数：
 *			nMode		[IN]: 通话类型，具体参考 WM_IM_CallType
 *			pJsonUsers	[IN]: 成员id列表 如{ "userids":["userid"]}
 * 返回值： 0-失败，其他-作为通话ID
*/
WM_IM_API int32_t WM_IM_Chat_Start(int32_t nMode, const char* pJsonUsers);

/*
 * 功能：发起通话（同步）
 * 参数：
 *			nMode		[IN]: 通话类型，具体参考 WM_IM_CallType
 *			pJsonUsers	[IN]: 成员id列表 如{ "userids":["userid"]}
 *          nGroupId	[IN]: 组id      
 * 返回值： 0-失败，其他-作为通话ID
*/
WM_IM_API int32_t WM_IM_Chat_StartGroup(int nGroupId, int32_t nMode, const char* pJsonUsers, int32_t& nResult);

/*
 * 功能：邀请他人加入（同步）
 * 参数：
 *			nChatId		[IN]: 通话Id
 *			pJsonUsers	[IN]: 成员id列表 如{ "userids":["userid"]}
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_Invite(int32_t nChatId, const char* pJsonUsers);

/*
 * 功能：取消邀请（同步）
 * 参数：
 *			nChatId		[IN]: 通话Id
 *			pJsonUsers	[IN]: 成员id列表 如{ "userids":["userid"]}
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_CancelInvite(int32_t nChatId, const char* pJsonUsers);

/*
 * 功能：通话邀请回应
 * 参数：
 *			nChatId		[IN]: 通话ID
 *			nAccept		[IN]: 0 接受，1 拒绝
 *			pOutBuf		[OUT]: 结果输出，通话成员, [{"userid":1, "callstatus":1},...]  callstatus: 0-邀请中 1-通话中 2-已拒绝 3-已挂断 4-已离线
 *			nBufLen		[IN]: pOutBuf大小
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_CalleeAck(int32_t nChatId, int32_t nSponsorId, int32_t nAccept, char* pOutBuf, int32_t nBufLen);

/*
 * 功能：结束通话（同步）
 * 参数：
 *			nChatId		[IN]: 通话ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_End(int32_t nChatId);

/*
 * 功能：加入通话（同步）
 * 参数：
 *			nChatId		[IN]: 通话ID
 *			pOutBuf		[OUT]: 结果输出，通话成员: {"users":[{"userid":1, "callstatus":1},...], "chattype": } 
 *														callstatus: 0-邀请中 1-通话中 2-已拒绝 3-已挂断 4-已离线
 *			nBufLen		[IN]: pOutBuf大小
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_Join(int32_t nChatId, char* pOutBuf, int32_t nBufLen);

/*
 * 功能：通话控制
 * 参数：
 *			nChatId		[IN]: 通话ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_Control(int32_t nChatId);

/*
 * 功能：通话禁言
 * 参数：
 *			nChatId		[IN]: 通话ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_Gag(int32_t nChatId);

/*
 * 功能：抢麦(同步)
 * 参数：
 *			nChatId		[IN]: 通话ID
 *			pOutBuf		[OUT]: 结果输出，通话成员, {"result", "userid", "time"}, result:结果， userid:占麦者ID， time:抢麦时间
 *			nBufLen		[IN]: pOutBuf大小
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_RobMic(int32_t nChatId, char* pOutBuf, int32_t nBufLen);

/*
 * 功能：放麦(同步)
 * 参数：
 *			nChatId		[IN]: 通话ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_FreeMic(int32_t nChatId);

/*
 * 功能：聊天室踢人(同步)
 * 参数：
 *			nChatId		[IN]: 通话ID
 *			userid		[IN]: 成员ID
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_IM_API int32_t WM_IM_Chat_KickOut(int32_t nChatId, int32_t nUserId);


