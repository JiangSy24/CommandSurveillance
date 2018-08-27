//
//  CSUrlString.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSUrlString.h"
#import "CSIPPortStringModel.h"
#import "WMAuthenticateSdk.h"

@implementation OutLibModel
@end

@implementation VersionModel
@end

@implementation SysconfModel
@end

@implementation Authenticate

@end

@interface CSUrlString ()

@property (nonatomic,copy) NSString *strinitIp;

@end

void WMAuthenticateSvrMsgCallBack(int32_t nMsgId, uint32_t nResultCode, void* pUser){
    
    if ([CSUrlString instance].authenticateCallBack) {
        [CSUrlString instance].authenticateCallBack(nMsgId);
    }
}

@implementation CSUrlString

- (NSString*)strRegUrl{
    int port = self.port / 1000 * 1000 + 80;
    return [NSString stringWithFormat:@"http://%@:%d",self.ip,port];
}

+ (instancetype)instance
{
//    static dispatch_once_t  onceToken;
    static CSUrlString* url = nil;
    if (url == nil) {
        url = [[[self class] alloc] init];
    }

    CSIPPortStringModel *list = [CSIPPortStringModel list];
    if (list != nil && (list.strIpPort.count > 0)) {
        
        NSArray *array = [list.strIpPort[0] componentsSeparatedByString:@":"];
        NSString *strPort = array[1];
        url.strUrl = [NSString stringWithFormat:@"http://%@:%d",array[0],strPort.intValue];
        url.ip = array[0];
        url.port = strPort.intValue;
        return url;
    }

//    if ((url != nil)&&!url.bErr) {
//        return url;
//    }
    //1.确定请求路径
    NSURL *urlA = [NSURL URLWithString:@"http://www.zhangxun360.com/addr.php"];

    // 清缓存
    [[NSURLCache sharedURLCache]removeAllCachedResponses];
    //3.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求路径
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     注意：
     1）该方法内部会自动将请求路径包装成一个请求对象，该请求对象默认包含了请求头信息和请求方法（GET）
     2）如果要发送的是POST请求，则不能使用该方法
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:urlA cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:3.f];
    
    
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.根据会话对象创建一个Task(发送请求）
    /*
     第一个参数：请求对象
     第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
     data：响应体信息（期望的数据）
     response：响应头信息，主要是对服务器端的描述
     error：错误信息，如果请求失败，则error有值
     */
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *ip;
        int port = 8051;
        
        if (error)
        {
            ip = @"118.244.236.67";
        }
        else
        {
            NSDictionary *ipandport = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            ip = ipandport[@"ip"];
            
            port = [ipandport[@"port"] intValue];
        }
        
//        // 假
//        ip = @"192.168.0.174";
//        port = 8000;


        url.strUrl = [NSString stringWithFormat:@"http://%@:%d",ip,port];
        url.ip = ip;
        url.port = port;
        url.bErr = NO;
        if (error) {
            url.bErr = YES;
        }
        
        // 发送信号量
        dispatch_semaphore_signal(semaphore);
    }];
    
    //5.执行任务
    [dataTask resume];
    dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待

    return url;
}

- (int)initAuthenticateIp:(NSString*)strIp port:(int)iPort{
    self.strinitIp = strIp;
    // 认证服务器
    WM_Authenticate_EnvCfg envCfg;
    envCfg.m_callbackFunc = WMAuthenticateSvrMsgCallBack;
    envCfg.m_nLogLevel = 255;
    strcpy(envCfg.m_szSvrIp, strIp.UTF8String);
    envCfg.m_nPort = iPort;
    int iRet = WM_Authenticate_Init(envCfg);
    return iRet;
}

- (void)uinitAuthenticate{
    WM_Authenticate_Uninit();
}

- (void)dealloc{
//    WM_Authenticate_Uninit();
}

- (int)Authenticate_LoginType:(int)iType userName:(NSString*)strUserName passWord:(NSString*)strPassword{
    int iret =  WM_Authenticate_Login(iType,(char*)strUserName.UTF8String, (char*)strPassword.UTF8String);
    return iret;
}

- (void)Authenticate_Logout{
    WM_Authenticate_Logout();
}

- (void)Authenticate_GetSysConfSuccess:(void (^)(Authenticate*))success failure:(void (^)(int))failure{
    char szBuf[PATH_MAX] = {0};
    int iret = WM_Authenticate_GetSysConf(szBuf, PATH_MAX);
    NSString *strJosn = [NSString stringWithUTF8String:szBuf];
    NSLog(@"%@",strJosn);
    Authenticate* account = [Authenticate mj_objectWithKeyValues:strJosn];
    account.userInfoAddress = [NSString stringWithFormat:@"http://%@:%d",self.strinitIp,account.sysconf.httpport];
    account.chatAddress = [NSString stringWithFormat:@"http://%@:%d/?",account.sysconf.imsvrip,account.sysconf.imsvrhttpport];
    
    self.account = account;
    if ((iret == 0) &&
        (nil != strJosn)) {
        if (success) {
            success(account);
        }
    }else{
        if (failure) {
            failure(iret);
        }
    }
}

@end
