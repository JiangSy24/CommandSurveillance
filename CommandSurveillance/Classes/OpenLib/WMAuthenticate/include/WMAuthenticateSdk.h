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


/********************************API �ӿ�*******************************************/
/*
 * ���ܣ���ʼ�����������нӿ�֮ǰ���ã���־�ĳ�ʼ������Դ�����룩
 * ������
 *			envCfg		[IN]: ������������
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Init(WM_Authenticate_EnvCfg& envCfg);

/*
 * ���ܣ��������ͷ�Init�������Դ����־�ķ���ʼ����
 * ��������
 * ����ֵ�� ��
*/
WM_AUTHENTICATE_API void WM_Authenticate_Uninit();

/*
 * ���ܣ����������֤
 * ������
 *			nAuthType		[IN]: ��֤��ʽ, 1-������֤ 2-��֤����֤
 *			pszUserMark		[IN]: �û���
 *			pszCheckKey		[IN]: ��֤key
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Login(int8_t nAuthType, char* pszUserMark, char* pszCheckKey);

/*
 * ���ܣ�ע��
 * ������
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_Logout();

/*
 * ���ܣ���ȡϵͳ����
 * ������
 *			szSysConf		[IN]: ϵͳ����
 *			nMaxConfLen		[IN]: ������������Ϣ�Ļ�������󳤶�
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_AUTHENTICATE_API int32_t WM_Authenticate_GetSysConf(char* szSysConf, int32_t nMaxConfLen);





