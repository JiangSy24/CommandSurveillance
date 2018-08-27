//
//  CSLoginIPVController.m
//  CloudSurveillance
//
//  Created by liangcong on 17/6/9.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import "CSLoginIPVController.h"
#import "CSIPPortStringModel.h"
#import "CSIPListCell.h"
@interface CSLoginIPVController()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *doneInKeyboardButton;
}
@property (weak, nonatomic) IBOutlet UITextField *inputIpEdit;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) CSIPPortStringModel *model;
@property (nonatomic, strong) UIButton *searchButton;
@end
@implementation CSLoginIPVController
+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"LoginIPListVController"];
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clear:(id)sender {
    self.inputIpEdit.text = nil;
}
- (IBAction)confirm:(id)sender {
    
    do {
        NSArray *array = [self.inputIpEdit.text componentsSeparatedByString:@":"];
        NSString *port = @"8051";
            [MBProgressHUD showTips:@"输入格式不正确" detail:nil forView:self.view];
        if (array.count == 2 && ((NSString*)array[1]).length > 0) {
            NSString *strSec = array[1];
            int  iOne = [[array[1] substringWithRange:NSMakeRange(0,1)] intValue];
            if (iOne == 0) {
                [MBProgressHUD showTips:@"输入端口格式不正确" detail:nil forView:self.view];
                break;
            }
            
            if (![NSString isOnlyNum:array[1]]) {
                [MBProgressHUD showTips:@"端口有非法字符" detail:nil forView:self.view];
                break;
            }
            port = array[1];
            
        }
        
        BOOL bIsOk = [self validateEmail:array[0]];
        if (bIsOk &&
            self.delegate &&
            [self.delegate respondsToSelector:@selector(getIp:port:)])
        {
            
            [self.delegate getIp:array[0] port:port.intValue];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTips:@"非法IP地址" detail:nil forView:self.view];
        }
            
    } while (FALSE);
}

- (void)viewDidLoad{
    //注册键盘显示通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //注册键盘隐藏通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.model = [CSIPPortStringModel list];
    self.navigationItem.titleView = [CSViewStyle changeNavTitleByFontSize:@"设置登录IP"];
    self.inputIpEdit.text = self.strip;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidDisappear:(BOOL)animated{
    //注销键盘显示通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// 键盘出现处理事件
- (void)handleKeyboardDidShow:(NSNotification *)notification
{
    
}

// 键盘消失处理事件
- (void)handleKeyboardWillHide:(NSNotification *)notification
{

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.inputIpEdit.text = self.model.strIpPort[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.strIpPort.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CSIPListCell *playcell = [tableView dequeueReusableCellWithIdentifier:@"ipport"];
    playcell.ipporty.text = self.model.strIpPort[indexPath.row];
    playcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return playcell;
}

- (BOOL)validateEmail:(NSString*)ip
{
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    return [self validateWithRegExp: urlRegEx/*@"\\d+\\.\\d+\\.\\d+\\.\\d+"*/ ip:ip];
}

- (BOOL)validateWithRegExp: (NSString *)regExp ip:(NSString*)ip
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", regExp];
    return [predicate evaluateWithObject: ip];
}
@end
