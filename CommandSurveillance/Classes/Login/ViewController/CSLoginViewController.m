//
//  CSLoginViewController.m
//  CloudSurveillance
//
//  Created by liangcong on 16/7/27.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSLoginViewController.h"
#import "CSLoginIPVController.h"
//#import "CSPlayTool.h"
#import "CSMainTabNavigation.h"
#import "CSLoginParam.h"
#import "IMChatManageTool.h"
#import "LMRegisterModle.h"
#import "CSIPPortStringModel.h"
#import "CSLocationSendVC.h"

@interface CSLoginViewController ()<UITextFieldDelegate,CSTextFieldDelegate,CSLoginIPVCDelegate>
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet CSTextField *phoneNumText;
@property (weak, nonatomic) IBOutlet CSTextField *passwordText;
@property (strong, nonatomic) UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UIButton *eyeIsWatchPassWord;
//@property (strong, nonatomic) MBProgressHUD * hud;
@property (strong, nonatomic) CSUrlString *strUrl;
@end

@implementation CSLoginViewController

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginViewController"];
}

- (IBAction)ipBtnClick:(id)sender {
    
    CSLoginIPVController *vc = [CSLoginIPVController myTableViewController];
    vc.delegate = self;
    vc.strip = [NSString stringWithFormat:@"%@:%d",self.strUrl.ip,self.strUrl.port];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark CSTextFieldDelegate
- (void)deleteBackward:(CSTextField *)textFiled{
    if (textFiled == self.phoneNumText) {
        self.userHeadImage.image = [UIImage imageNamed:@"personal_defaultplayerIcon"];
    }
}
#pragma mark CSLoginIPVCDelegate
- (void)getIp:(NSString *)ip port:(int)port{
    CSUrlString *strUrl = [[CSUrlString alloc] init];
    strUrl.ip = ip;
    strUrl.port = port;
    strUrl.strUrl = [NSString stringWithFormat:@"http://%@:%d",ip,port];
    self.strUrl = strUrl;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.strUrl = [CSUrlString instance];
    self.navigationController.navigationBarHidden = YES;
    // 创建问题临时文件夹
    NSString *pathSnapTem = ScreenPath;//Documents,Library,tmp
    NSLog(@"pathTem : %@", pathSnapTem);
    
    NSFileManager *fmSnapTem = [NSFileManager defaultManager];
    BOOL isDirSnapTem;
    BOOL isExistsSnapTem = [fmSnapTem fileExistsAtPath:pathSnapTem isDirectory:&isDirSnapTem];
    if (!isExistsSnapTem) {
        [fmSnapTem createDirectoryAtPath:pathSnapTem withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    // 创建抓图片目录
    NSString *pathSnap = SnapPath;//Documents,Library,tmp
    NSLog(@"path : %@", pathSnap);
    
    NSFileManager *fmSnap = [NSFileManager defaultManager];
    BOOL isDirSnap;
    BOOL isExistsSnap = [fmSnap fileExistsAtPath:pathSnap isDirectory:&isDirSnap];
    if (!isExistsSnap) {
        [fmSnap createDirectoryAtPath:pathSnap withIntermediateDirectories:YES attributes:nil error:NULL];
    }

    [self initAllViews];
}

- (void)initAllViews{

    UIImage *backImage =[UIImage imageNamed:@"login_back.png"];
    
    // 图片拉伸
    self.view.layer.contents=(id)backImage.CGImage;
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
//    [CSViewStyle initInputView:self.passwordView];
//    [CSViewStyle initInputView:self.phoneNumView];
    [self.phoneNumText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 呼出键盘样式
//    self.phoneNumText.keyboardType =UIKeyboardTypeNumberPad;
    self.passwordText.keyboardType = UIKeyboardTypeAlphabet;
    self.passwordText.secureTextEntry = YES;

    [self.eyeIsWatchPassWord setImage:[UIImage imageNamed:@"eye_password"] forState:UIControlStateHighlighted];
    //处理按钮点击事件
    [self.eyeIsWatchPassWord addTarget:self action:@selector(TouchDown)forControlEvents: UIControlEventTouchDown];
    //处理按钮松开状态
    [self.eyeIsWatchPassWord addTarget:self action:@selector(TouchUp)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.phoneNumText.delegate = self;
    self.passwordText.delegate = self;
    self.phoneNumText.csdelegate = self;

}

- (UIImageView*)userHeadImage{
    if (_userHeadImage == nil) {
        
        // 设置头像位置，因为phoneText是垂直居中的
        float makeWidth = [UIScreen mainScreen].bounds.size.width / 3.f;
        float fUserHeadtop = ([UIScreen mainScreen].bounds.size.height / 2 - makeWidth) / 2;
        
        UIImageView* userImage = [[UIImageView alloc]init];
//        userImage.backgroundColor = [UIColor grayColor];
        userImage.layer.cornerRadius = makeWidth / 2.f;
        userImage.layer.masksToBounds = YES;
        userImage.clipsToBounds = YES;
        self.userHeadImage = userImage;
        [self.view addSubview:userImage];
        [self.userHeadImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.mas_equalTo(fUserHeadtop).priorityLow();
            make.width.height.mas_equalTo(makeWidth).priorityLow();
        }];
    }
    return _userHeadImage;
}

- (void)viewDidAppear:(BOOL)animated{
    self.userHeadImage.image = [UIImage imageNamed:@"personal_defaultplayerIcon"];
    CSUserInfo *userInfo = [CSAccountTool userInfo];
    if (nil != userInfo) {
                CGSize sSize = CGSizeMake(128, 128);
        
        if (userInfo.userImage != nil) {
            self.userHeadImage.image = [self circleImage:userInfo.userImage withParam:0];//[self imageWithImage:userInfo.userImage scaledToSize:sSize];//userInfo.userImage;
        }

        self.userHeadImage.backgroundColor = [UIColor clearColor];
        self.phoneNumText.text = userInfo.phoneNum;
        self.passwordText.text = userInfo.password;
    }
}

-(UIImage*)circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    //圆的边框宽度为2，颜色为红色
    
    CGContextSetLineWidth(context,2);
    
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    //在圆区域内画出image原图
    
    [image drawInRect:rect];
    
    CGContextAddEllipseInRect(context, rect);
    
    CGContextStrokePath(context);
    
    //生成新的image
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
    
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)TouchDown
{
    //这里可以处理其他点击事件
    self.passwordText.secureTextEntry = !self.passwordText.secureTextEntry;
    NSLog(@"按钮点击了");
    if (!self.passwordText.secureTextEntry) {
        [self.eyeIsWatchPassWord setImage:[UIImage imageNamed:@"eye_password"] forState:UIControlStateNormal];
    }else{
        [self.eyeIsWatchPassWord setImage:[UIImage imageNamed:@"eye_password_select"] forState:UIControlStateNormal];
    }
}

- (void)TouchUp
{
    //这里可以处理其他松开事件
//    NSLog(@"按钮松开了");
//    [self.eyeIsWatchPassWord setImage:[UIImage imageNamed:@"eye_password"] forState:UIControlStateNormal];
//    self.passwordText.secureTextEntry = YES;
}

#pragma mark -----text代理------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    BOOL bStatus = NO;
    
    if (LoginPhoneNum_TextField == textField.tag) {
        // 手机号不超过11位
        bStatus = (range.location + string.length) <= CSPhoneNumSize;
        
        CSUserInfo *userInfo = [CSAccountTool userInfo];
        if (nil != userInfo) {
            
            if ([string isEqualToString:userInfo.phoneNum]) {

                if (userInfo.userImage != nil) {
                    self.userHeadImage.image = [self circleImage:userInfo.userImage withParam:0];//[self imageWithImage:userInfo.userImage scaledToSize:sSize];//userInfo.userImage;
                }

            }
        }
        
    }else if (LoginPassword_TextField == textField.tag){
        // 密码不超过12位
        bStatus = (range.location + string.length) <= CSPassWordMaxSize;
    }
    
    return bStatus;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

/**
 *  登录，成功登录要存储密码
 */
- (IBAction)loginFun:(id)sender {

    do {
        if ((0 == self.phoneNumText.text.length)||
            (0 == self.phoneNumText.text.length)){
            [MBProgressHUD showTips:CSStrLoginErr detail:nil forView:self.view];
            break;
        }
        
        [[NSURLCache sharedURLCache]removeAllCachedResponses]; // 清缓存 url的，防止登录失败后返回结果还是失败
        
        [self.view endEditing:YES];
        
        if ((0 == self.phoneNumText.text.length)||
            (0 == self.phoneNumText.text.length)){
            [MBProgressHUD showTips:CSStrLoginErr detail:nil forView:self.view];
            break;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSString *phone =  [self.phoneNumText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *pass = self.passwordText.text;
        // 清缓存
        [[NSURLCache sharedURLCache]removeAllCachedResponses];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            CSLoginParam *accoutParam = [[CSLoginParam alloc] init];

            [[IMChatManageTool instance] chatLoginUserName:phone passWord:pass ipAddress:self.strUrl.ip port:self.strUrl.port success:^(Authenticate *model) {
                
                accoutParam.signature = model.sysconf.signature;
                accoutParam.msgid = 259;
                accoutParam.pageid = 0;
                accoutParam.pagecount = 0;
                accoutParam.userid = model.sysconf.accountid;
                
                NSLog(@"Login param: userid[%d] msgid[%d] signature[%@]",
                      accoutParam.userid,
                      accoutParam.msgid,
                      accoutParam.signature);
                
                [CZHttpTool Post:[CSUrlString instance].account.userInfoAddress  parameters:accoutParam.mj_keyValues success:^(id responseObject){
                    NSLog(@"Login responseObject:%@",responseObject);
                    CSUsersModel* models = [CSUsersModel mj_objectWithKeyValues:responseObject];
                    
                    if (models.result == 0) {
                        //成功
                        CSAccount *account = [[CSAccount alloc] init];
                        account.veyeuserid = self.phoneNumText.text;
                        account.veyekey = self.passwordText.text;
                        account.iPicQuality = [CSAccountTool account].iPicQuality;
                        [CSAccountTool saveAccount:account];
                        
                        CSUserInfo *userInfo = [CSAccountTool userInfo];
                        if (nil == userInfo) {
                            userInfo = [[CSUserInfo alloc] init];
                        }
                        userInfo.phoneNum = self.phoneNumText.text;
                        userInfo.password = self.passwordText.text;
                        
                        [CSUsersModel instance].accounts = models.accounts;
                        [[CSUsersModel instance] makeData];
                        [CSAccountTool saveUserInfo:userInfo];
                        // 记录ip
                        CSIPPortStringModel *list = [CSIPPortStringModel list];
                        if (list == nil) {
                            list = [[CSIPPortStringModel alloc] init];
                        }
                        [list insert:self.strUrl.ip port:self.strUrl.port];
                        [CSIPPortStringModel saveIpList:list];
                        [hud hideAnimated:YES];
                        [CSAccountTool skipToMainTabBarController];
                    }
                    
                } failure:^(NSError *error) {
                    
                    NSLog(@"userid%d",[CSAccountTool account].userid);
                    // 获取人名，标签
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        [MBProgressHUD showTips:@"登录失败.." detail:nil forView:self.view];
                        // 成功
                    });
                    
                }];
                
            } failure:^(int error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    // 认证服务器登录失败
                    [MBProgressHUD showTips:[CSStatusTool getErrorStrInfo:error] detail:nil forView:self.view];
                });
            }];
            
        });

    } while (FALSE);

}

- (void)saveHeadImage{
    CSUserInfo *userInfo = [CSAccountTool userInfo];
    if (nil == userInfo) {
        userInfo = [[CSUserInfo alloc] init];
    }
    userInfo.userImage = self.userHeadImage.image;
    [CSAccountTool saveUserInfo:userInfo];
}

@end
