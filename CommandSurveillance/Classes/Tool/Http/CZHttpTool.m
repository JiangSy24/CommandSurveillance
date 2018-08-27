//
//  CZHttpTool.m
//
//  Created by apple on 15-3-10.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "CZHttpTool.h"
#import "CZAccountParam.h"
#import "AFNetworking.h"
//#import "VomontNetWorking/VomontNetWorking.h"

@implementation CZHttpTool

+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 3.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"这里打印请求成功要做的事");
        // AFN请求成功时候调用block
        // 先把请求成功要做的事情，保存到这个代码块
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);  //这里打印错误信息
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)Post:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:3.f];
    
    //    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //        NSLog(@"asdfad");
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        if (success) {
    //            success(responseObject);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (failure) {
    //            failure(error);
    //        }
    //    }];
    
    [manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

#define CZAuthorizeBaseUrl @"https://api.weibo.com/oauth2/authorize"
#define CZClient_id     @"2389394849"
#define CZRedirect_uri  @"http://www.baidu.com"
#define CZClient_secret @"03729d16a4cd277c7da26398f7a01282"

+ (void)accountWithCode:(NSString *)code success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    
    // 创建参数模型
    CZAccountParam *param = [[CZAccountParam alloc] init];
    param.client_id = CZClient_id;
    param.client_secret = CZClient_secret;
    param.grant_type = @"authorization_code";
    param.code = code;
    param.redirect_uri = CZRedirect_uri;
    
    [CZHttpTool Post:@"https://api.weibo.com/oauth2/access_token" parameters:param.mj_keyValues success:^(id responseObject) {
        // 字典转模型
//        CZAccount *account = [CZAccount accountWithDict:responseObject];
        
        // 保存账号信息:
        // 数据存储一般我们开发中会搞一个业务类，专门处理数据的存储
        // 以后我不想归档，用数据库，直接改业务类
//        [CZAccountTool saveAccount:account];
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getAllDeviceInfoSuccess:(NSString*)strUrl  success:(void (^)())success failure:(void (^)())failure{
    
    /*
     HttpMsgId_GetFactoryList
     
     HYPERLINK "http://ip:port/msgid=0x103&userid=100" http://ip:port/?msgid=304&userid=100
     ip:服务器IP地址；
     port:服务器端口号（默认8050）；
     msgid:消息ID，参见HttpMsgId定义；
     userid:用户ID（登录返回的userid）; 18551413186 123456
     */
//    [[CSGlobalFactoryList instance] clearAllNSArray];
//    // 验证注册信息
//    CSAccountParam* accoutParam = [[CSAccountParam alloc]init];
//    //        CSLoginParam *accoutParam = [[CSLoginParam alloc] init];
//    accoutParam.userid = [CSUrlString instance].account.userid;
//    accoutParam.signature = [CSUrlString instance].account.signature;
//    accoutParam.msgid = 368;
//
//    NSLog(@"getfactorysList ");
//    
//    [CZHttpTool Post:[CSUrlString instance].account.address parameters:accoutParam.mj_keyValues success:^(id responseObject) {
//        NSLog(@"getfactorylist responseObject %@",responseObject);
//        
//        CSFactoryListModel *factory = [CSFactoryListModel mj_objectWithKeyValues:responseObject];
//        if (ErrorCode_Invalid == factory.result) {
//            
//            [[CSGlobalFactoryList instance].factorys addObjectsFromArray:factory.factorys];
//            [[CSGlobalFactoryList instance].subfactorys addObjectsFromArray:factory.subfactorys];
//            [[CSGlobalFactoryList instance].devices addObjectsFromArray:factory.devices];
//            
//            int iAllOnlineDevices = 0;
//            int iAllDevices = 0;
//            int iAllSubFactoryBand = 0;
//            for (CSFactorysModel *temFactory in [CSGlobalFactoryList instance].factorys) {
//                temFactory.factoryname = [CSStatusTool _859ToUTF8:temFactory.factoryname];
//                int iSubDevices = 0;
//                int iSubOnlineDevices = 0;
//                int iSubFactoryBand = 0;
//                for (CSSubfactorysModel *temsubfactory in [CSGlobalFactoryList instance].subfactorys) {
//                    if (temFactory.factoryid == temsubfactory.ownerfactoryid) {
//                        // 如果相等那么厂区就是该工厂的
//                        for (CSDevicesModel *temDevices in [CSGlobalFactoryList instance].devices) {
//                            if (temDevices.subfactoryid == temsubfactory.subfactoryid) {
//                                temsubfactory.iAvailpercent = 100;
//                                temDevices.devicename = [CSStatusTool _859ToUTF8:temDevices.devicename];
//                                [temsubfactory.devicesArray addObject:temDevices];
//                                iAllDevices++;
//                                iSubDevices++;
//                                if (temDevices.online == 1) {
//                                    iAllOnlineDevices++;
//                                    iSubOnlineDevices++;
//                                }
//                            }
//                        }
//                        temsubfactory.subfactoryname = [CSStatusTool _859ToUTF8:temsubfactory.subfactoryname];
//                        [temFactory.subfactoryArray addObject:temsubfactory];
//
//                        if (temsubfactory.iAvailpercent == 100) {
//                            iSubFactoryBand++;
//                            iAllSubFactoryBand++;
//                        }
//                        
//                    }
//
//                }
//                
//                temFactory.iAvailpercent = iSubFactoryBand*100 / temFactory.subfactoryArray.count;
//                // 工厂的device
//                temFactory.iAllDevice = iSubDevices;
//                temFactory.iAllOnlineDevice = iSubOnlineDevices;
//            }
//            [CSGlobalFactoryList instance].iAllbanddevice = iAllDevices;
//            [CSGlobalFactoryList instance].iOnlinepercent = iAllOnlineDevices*100 / iAllDevices;
//            [CSGlobalFactoryList instance].iAvailpercent = iAllSubFactoryBand*100 / [CSGlobalFactoryList instance].subfactorys.count;
//            
//        }
//        if (success) {
//            success();
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%s err",__func__);
//        if (failure) {
//            failure();
//        }
//    }];
    
}

+ (void)sendImageFile:(NSString*)imageFilePath success:(void (^)(NSString* severfileName))success failure:(void (^)(void))failure{

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        VMUpLoadNetWorking *netWork = [[VMUpLoadNetWorking alloc] init];
        [netWork initNetWorkingIp:[CSUrlString instance].account.sysconf.vfilesvrip port:[CSUrlString instance].account.sysconf.vfilesvrhttpport accountId:[CSUrlString instance].account.sysconf.accountid];

        __block BOOL bIsSuccess = YES;
        __block NSString *strFileName = nil;

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [netWork vFileUploadBigFile:imageFilePath fileIdx:nil process:^(NSString *key, float percent, float sendSize) {

        } success:^(NSString *strD) {
            NSLog(@"123 %@",strD);//http://192.168.0.187:8080/7/7-761bb8d147befef1.jpg
            strFileName = strD;
            dispatch_semaphore_signal(semaphore);
        } fail:^(int error) {
            bIsSuccess = NO;
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore,DISPATCH_TIME_FOREVER);  //等待

        if (!bIsSuccess) {
            if (failure) {
                failure();
            }
        }else{
            if (success) {
                success(strFileName);
            }
        }
    });

}

@end
