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


/********************************API �ӿ�*******************************************/
/*
 * ���ܣ���ʼ�����������нӿ�֮ǰ���ã���־�ĳ�ʼ������Դ�����룩
 * ������
 *			envCfg		[IN]: ������������
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Init(WM_IM_EnvConfigure& envCfg);

/*
 * ���ܣ��������ͷ�Init�������Դ����־�ķ���ʼ����
 * ��������
 * ����ֵ�� ��
*/
WM_IM_API void WM_IM_Uninit();

/*
 * ���ܣ��������ע�ᣨ�첽��
 * ������
 *			nUserId			[IN]: �û�ID
 *			pszSignature	[IN]: ǩ��(���ȴ���)
 *			pszMacCode		[IN]: ������(���ȴ���)
 *			registerCB		[IN]:��¼�ص�����(�ص���Ϣ�����������û���Ϣ��Ⱥ����Ϣ)	
 *			pUser			[IN]:�û�����
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Register(uint32_t nUserId, const char* pszSignature, const char* pszMacCode, fWMRegisterMsgCallBack registerCB, void* pUser);

/*
 * ���ܣ�ע��
 * ������
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_UnRegister();

/*
 * ���ܣ�����Ⱥ�飨ͬ����
 * ������
 *			pGroupName	[IN]: ����Ϣ
 * ����ֵ�� -1-ʧ�ܣ�������Ϊ��ID
*/
WM_IM_API int32_t WM_IM_GroupCreat(char* const pGroupName);

/*
 * ���ܣ���ӳ�Ա��ͬ����
 * ������
 *			nGroupId	[IN]: ��ID
 *			pMemsJson	[IN]: ��Աid�б� ��{ "userids":["userid"]}
 * ����ֵ�� 0-�ɹ�������ʧ��
*/
WM_IM_API int32_t WM_IM_GroupInviteMember(int32_t nGroupId, const char* pMemsJson);

/*
 * ���ܣ����˳�Ⱥ��ͬ����
 * ������
 *			nGroupId	[IN]: ��Id
 *			nUserId		[IN]: ���߳�ԱID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_GroupKickOut(int32_t nGroupId, int32_t nUserId);

/*
 * ���ܣ�������Ⱥ��ͬ����
 * ������
 *			nGroupId	[IN]: ��Id
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_GroupHadLeft(int32_t nGroupId);

/*
 * ���ܣ���ɢȺ�飨ͬ����
 * ������
 *			nGroupId	[IN]: ��Id
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_GroupDissolve(int32_t nGroupId);

/*
 * ���ܣ�����ͨ����Ϣ�ص�
 * ������
 *			chatMsgCB	[IN]: �ص�����
 *			pUser		[IN]: �û�����
 * ����ֵ�� 0-�ɹ�������-ʧ��
*/
WM_IM_API int32_t WM_IM_Chat_SetMsgCallBack(fWMCallMsgCallBack chatMsgCB, void* pUser);

/*
 * ���ܣ�����ͨ����ͬ����
 * ������
 *			nMode		[IN]: ͨ�����ͣ�����ο� WM_IM_CallType
 *			pJsonUsers	[IN]: ��Աid�б� ��{ "userids":["userid"]}
 * ����ֵ�� 0-ʧ�ܣ�����-��Ϊͨ��ID
*/
WM_IM_API int32_t WM_IM_Chat_Start(int32_t nMode, const char* pJsonUsers);

/*
 * ���ܣ�����ͨ����ͬ����
 * ������
 *			nMode		[IN]: ͨ�����ͣ�����ο� WM_IM_CallType
 *			pJsonUsers	[IN]: ��Աid�б� ��{ "userids":["userid"]}
 *          nGroupId	[IN]: ��id      
 * ����ֵ�� 0-ʧ�ܣ�����-��Ϊͨ��ID
*/
WM_IM_API int32_t WM_IM_Chat_StartGroup(int nGroupId, int32_t nMode, const char* pJsonUsers, int32_t& nResult);

/*
 * ���ܣ��������˼��루ͬ����
 * ������
 *			nChatId		[IN]: ͨ��Id
 *			pJsonUsers	[IN]: ��Աid�б� ��{ "userids":["userid"]}
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_Invite(int32_t nChatId, const char* pJsonUsers);

/*
 * ���ܣ�ȡ�����루ͬ����
 * ������
 *			nChatId		[IN]: ͨ��Id
 *			pJsonUsers	[IN]: ��Աid�б� ��{ "userids":["userid"]}
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_CancelInvite(int32_t nChatId, const char* pJsonUsers);

/*
 * ���ܣ�ͨ�������Ӧ
 * ������
 *			nChatId		[IN]: ͨ��ID
 *			nAccept		[IN]: 0 ���ܣ�1 �ܾ�
 *			pOutBuf		[OUT]: ��������ͨ����Ա, [{"userid":1, "callstatus":1},...]  callstatus: 0-������ 1-ͨ���� 2-�Ѿܾ� 3-�ѹҶ� 4-������
 *			nBufLen		[IN]: pOutBuf��С
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_CalleeAck(int32_t nChatId, int32_t nSponsorId, int32_t nAccept, char* pOutBuf, int32_t nBufLen);

/*
 * ���ܣ�����ͨ����ͬ����
 * ������
 *			nChatId		[IN]: ͨ��ID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_End(int32_t nChatId);

/*
 * ���ܣ�����ͨ����ͬ����
 * ������
 *			nChatId		[IN]: ͨ��ID
 *			pOutBuf		[OUT]: ��������ͨ����Ա: {"users":[{"userid":1, "callstatus":1},...], "chattype": } 
 *														callstatus: 0-������ 1-ͨ���� 2-�Ѿܾ� 3-�ѹҶ� 4-������
 *			nBufLen		[IN]: pOutBuf��С
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_Join(int32_t nChatId, char* pOutBuf, int32_t nBufLen);

/*
 * ���ܣ�ͨ������
 * ������
 *			nChatId		[IN]: ͨ��ID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_Control(int32_t nChatId);

/*
 * ���ܣ�ͨ������
 * ������
 *			nChatId		[IN]: ͨ��ID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_Gag(int32_t nChatId);

/*
 * ���ܣ�����(ͬ��)
 * ������
 *			nChatId		[IN]: ͨ��ID
 *			pOutBuf		[OUT]: ��������ͨ����Ա, {"result", "userid", "time"}, result:����� userid:ռ����ID�� time:����ʱ��
 *			nBufLen		[IN]: pOutBuf��С
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_RobMic(int32_t nChatId, char* pOutBuf, int32_t nBufLen);

/*
 * ���ܣ�����(ͬ��)
 * ������
 *			nChatId		[IN]: ͨ��ID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_FreeMic(int32_t nChatId);

/*
 * ���ܣ�����������(ͬ��)
 * ������
 *			nChatId		[IN]: ͨ��ID
 *			userid		[IN]: ��ԱID
 * ����ֵ�� 0-�ɹ���1-ʧ��, ����-������
*/
WM_IM_API int32_t WM_IM_Chat_KickOut(int32_t nChatId, int32_t nUserId);


