//
//  CSAccountTool.m
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSAccountTool.h"
#import "Reachability.h"
@implementation CSAccountTool

+ (void)sendMessageGetScode:(NSString*)phoneNum{
//    CSAccountParam* accoutParam = [[CSAccountParam alloc]init];
//    accoutParam.tel = phoneNum;//@"15642098808";
//    accoutParam.msgid = HttpMsgId_GetVerifCode;
//    // 干验证码
//    [CZHttpTool Post:[CSUrlString instance].account.address  parameters:accoutParam.mj_keyValues success:^(id responseObject) {
//        NSLog(@"getscode responseObject %@",responseObject);
//        //        CSAccount* account = [CSAccount accountWithDict:responseObject];
//    } failure:^(NSError *error) {
//        NSLog(@"err");
//    }];
}

+ (void)sendMessageGetScode:(NSString*)phoneNum url:(NSString*)strUrl success:(void (^)(CSAccount* account))getAccount{
//    CSAccountParam* accoutParam = [[CSAccountParam alloc]init];
//    accoutParam.tel = phoneNum;//@"15642098808";
//    accoutParam.msgid = HttpMsgId_GetVerifCode;
//    // 干验证码
//    [CZHttpTool Post:strUrl  parameters:accoutParam.mj_keyValues success:^(id responseObject) {
//        NSLog(@"getscode responseObject %@",responseObject);
//        CSAccount* account = [CSAccount accountWithDict:responseObject];
//        if (getAccount) {
//            getAccount(account);
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"err");
//    }];
}

+ (NSString*) getErrMsgFromResult:(int)result{
    NSString *strErr = nil;
    switch (result) {
        case ErrorCode_Invalid:
        {
            strErr = @"没有错误";
            break;
        }
        case ErrorCode_fail:
        {
            strErr = @"一般错误";
            break;
        }
        case ErrorCode_InvalidParameterEx:
        {
            strErr = @"参数有误";
            break;
        }
        case ErrorCode_GetVerifCodeFail:
        {
            strErr = @"获取验证码失败";
            break;
        }
        case ErrorCode_VerifCodeHasSend:
        {
            strErr = @"验证码已发送，请稍候";
            break;
        }
        case ErrorCode_HasRegister:
        {
            strErr = @"手机号已注册";
            break;
        }
        case ErrorCode_VerifCodeError:
        {
            strErr = @"验证码错误";
            break;
        }
        case ErrorCode_NoVerifyCode:
        {
            strErr = @"验证码未发送";
            break;
        }
        case ErrorCode_WriteDBFail:
        {
            strErr = @"写入数据库失败";
            break;
        }
        case ErrorCode_NotFindAccount:
        {
            strErr = @"未找到注册的手机号账户";
            break;
        }
        case ErrorCode_AccountHasLogin:
        {
            strErr = @"当前账号已登录";
            break;
        }
        case ErrorCode_PasswordErrorEx:
        {
            strErr = @"账户密码错误";
            break;
        }
        case ErrorCode_NotFindUserEx:
        {
            strErr = @"未找到登录用户";
            break;
        }
        case ErrorCode_SamePassword:
        {
            strErr = @"新密码与旧密码一致";
            break;
        }
        case ErrorCode_LoadPersonalIconFail:
        {
            strErr = @"加载个人头像失败";
            break;
        }
        case ErrorCode_SetPersonalIconFail:
        {
            strErr = @"查找写入个人头像失败";
            break;
        }
        case ErrorCode_FactoryNameExist:
        {
            strErr = @"工厂名称已存在";
            break;
        }
        case ErrorCode_FactoryNotFound:
        {
            strErr = @"工厂ID不存在";
            break;
        }
        case ErrorCode_SubFactoryNameExist:
        {
            strErr = @"厂区名称已存在";
            break;
        }
        case ErrorCode_SubFactoryNotFound:
        {
            strErr = @"厂区ID不存在";
            break;
        }
        case ErrorCode_DeviceNameExist:
        {
            strErr = @"设备名称已存在";
            break;
        }
        case ErrorCode_DeviceNotFound:
        {
            strErr = @"设备ID不存在";
            break;
        }
        case ErrorCode_AccountNameExist:
        {
            strErr = @"账户名称已存在";
            break;
        }
        case ErrorCode_AccountIdNotFound:
        {
            strErr = @"账户ID不存在";
            break;
        }
        case ErrorCode_ProblemTypeNameExist:
        {
            strErr = @"问题类型名称已存在";
            break;
        }
        case ErrorCode_ProblemTypeNotFound:
        {
            strErr = @"问题类型ID不存在";
            break;
        }
        case ErrorCode_ProblemTypeHasChild:
        {
            strErr = @"问题类型还存在子类";
            break;
        }
        case ErrorCode_ReadDBFail:
        {
            strErr = @"读取数据库失败";
            break;
        }
        case ErrorCode_NoPermission:
        {
            strErr = @"没有权限";
            break;
        }
        case ErrorCode_InvalidVerifyCode:
        {
            strErr = @"或已超时失效";
            break;
        }
        case ErrorCode_SendRegisterInviteFail:
        {
            strErr = @"发送注册邀请短消息失败";
            break;
        }
        case ErrorCode_HasJoin:
        {
            strErr = @"发送注册邀请短消息失败";
            break;
        }
        case ErrorCode_ProblemNotFound:
        {
            strErr = @"问题ID不存在";
            break;
        }
        case ErrorCode_NoProblemDescription:
        {
            strErr = @"没有问题描述说明";
            break;
        }
        case ErrorCode_InvalidAction:
        {
            strErr = @"无效的问题处理动作";
            break;
        }
        case ErrorCode_SameProblemAccount:
        {
            strErr = @"问题责任人和创建人不能是同一人";
            break;
        }
        case ErrorCode_NoActionRight:
        {
            strErr = @"没有问题处理的权限";
            break;
        }
        case ErrorCode_VideoNotFound:
        {
            strErr = @"录像ID不存在";
            break;
        }
        case ErrorCode_AsyncLoginEx:
        {
            strErr = @"异步登录";
            break;
        }
        case ErrorCode_ConnectFailEx:
        {
            strErr = @"连接失败";
            break;
        }
        case ErrorCode_InvalidVFileSvr:
        {
            strErr = @"无效的录像文件服务器";
            break;
        }
        case ErrorCode_WaitResultEx:
        {
            strErr = @"等待结果";
            break;
        }
        case ErrorCode_NotFindVFileSvr:
        {
            strErr = @"未找到vfilesvr";
            break;
        }
        case ErrorCode_InvalidProblemSource:
        {
            strErr = @"无效的问题来源";
            break;
        }
        default:
            break;
    }
    return strErr;
}

+ (void)skipToMainTabBarController{
    CSTabBarController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"TabBarController"];
    CSKeyWindow.rootViewController = vc;
}

static CSAccount *_account = nil;
+ (void)saveAccount:(CSAccount *)account
{
    _account = account;
    BOOL bIs = [NSKeyedArchiver archiveRootObject:account toFile:CZAccountFileName];
}

+ (CSAccount *)account
{
    if (_account == nil) {

        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:CZAccountFileName];

    }

    return _account;
}

static CSUserInfo *_userInfo = nil;
+ (void)saveUserInfo:(CSUserInfo *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:CZUserFileName];
}

+ (CSUserInfo *)userInfo
{
    if (_userInfo == nil) {
        
        _userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:CZUserFileName];
        
    }
    
    return _userInfo;
}

+ (void)deleteAccountFile{

    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:CZAccountFileName]) {
        [fm removeItemAtPath:CZAccountFileName error:nil];
        _account = nil;
    }

}

+ (void)deleteUserInfo{
    NSFileManager * fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:CZUserFileName]) {
        [fm removeItemAtPath:CZUserFileName error:nil];
        _userInfo = nil;
    }
}

+(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        return NO;
    }
    
    return isExistenceNetwork;
}

/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)zipImageWithImage:(UIImage *)image
{
    if (!image) {
        return nil;
    }
    CGFloat maxFileSize = 32*1024;
    CGFloat compression = 0.9f;
    NSData *compressedData = UIImageJPEGRepresentation(image, compression);
    while ([compressedData length] > maxFileSize) {
        compression *= 0.9;
        compressedData = UIImageJPEGRepresentation([self compressImage:image newWidth:image.size.width*compression], compression);
    }
    return compressedData;
}

/**
 *  等比缩放本图片大小，图片压缩
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
