#pragma once

#include "WMAuthenticateSdk_i.h"

#ifdef WIN32  
#ifdef WMAUTHENTICATESDK_EXPORTS
#define WM_AUTHENTICATE_API extern "C" __declspec(dllexport)
#else
#define WM_AUTHENTICATE_API extern "C" __declspec(dllimport)
#endif
#else
#define WM_AUTHENTICATE_API	extern "C"
#endif


/********************************API 接口*******************************************/
/*
 * 功能：初始化，调用所有接口之前调用（日志的初始化、资源的申请）
 * 参数：
 *			envCfg		[IN]: 基本环境配置
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Init(WM_Authenticate_EnvCfg& envCfg);

/*
 * 功能：析构（释放Init申请的资源、日志的反初始化）
 * 参数：无
 * 返回值： 无
*/
WM_AUTHENTICATE_API void WM_Authenticate_Uninit();

/*
 * 功能：向服务器认证
 * 参数：
 *			nAuthType		[IN]: 认证方式, 1-密码认证 2-验证码认证
 *			pszUserMark		[IN]: 用户名
 *			pszCheckKey		[IN]: 认证key
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Login(int8_t nAuthType, char* pszUserMark, char* pszCheckKey);

/*
 * 功能：注销
 * 参数：
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Logout();

/*
 * 功能：获取系统配置
 * 参数：
 *			szSysConf		[IN]: 系统配置
 *			nMaxConfLen		[IN]: 允许存放配置信息的缓冲区最大长度
 * 返回值： 0-成功，1-失败, 其他-错误码
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_GetSysConf(char* szSysConf, int32_t nMaxConfLen);





