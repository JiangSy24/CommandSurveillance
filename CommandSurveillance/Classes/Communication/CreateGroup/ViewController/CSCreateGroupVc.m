//
//  CSCreateGroupVc.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/24.
//  Copyright © 2018年 liangcong. All rights reserved.
//
#import "CSCreateGroupVc.h"
#import "CSCreateGroupHeaderView.h"
#import "CSGroupUserShowCell.h"
#import "CSCmChoiceVc.h"
#import "CSCreateGroupCell.h"

@interface CSCreateGroupVc ()<UITableViewDelegate,UITableViewDataSource,CSGroupUserShowCellDelegate,CSCmChoiceVcDelegate,CSCreateGroupCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSString *groupName;
@end

@implementation CSCreateGroupVc

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CreateGroupVc"];
}

- (IBAction)confirmBtnClick:(id)sender {
    if (self.groupName.length == 0) {
        [MBProgressHUD showTips:@"组名不能为空" detail:nil forView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[IMChatManageTool instance].teamManage creatNewGroup:self.groupName members:self.array success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 成功
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(int error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 失败
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showTips:@"创建失败" detail:nil forView:self.view];
        });
    }];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.CSCreateGroupHeaderView
//    [CSViewStyle initInputViewRound:self.logoViewBox];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CSCreateGroupHeaderView *vw = [CSCreateGroupHeaderView appInfoView];
    //    vw.delegate = self;
    self.tableView.tableHeaderView = vw;
    [CSViewStyle initInputView:self.confirmBtn color:[UIColor clearColor]];
}

- (void)updateHeaderView{
    CSCreateGroupHeaderView *vw = (CSCreateGroupHeaderView*)self.tableView.tableHeaderView;
    vw.threeViewBox.hidden = YES;
    vw.moreViewBox.hidden = YES;
    if (self.array.count <= 3) {
        vw.threeViewBox.hidden = NO;
        for (int i = 0; i < self.array.count; i++) {
            switch (i) {
                case 0:
                {
                    vw.three_labelOne.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 1:
                {
                    vw.three_labeltwo.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 2:
                {
                    vw.three_labelthree.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                default:
                    break;
            }
        }
    }else{
        vw.moreViewBox.hidden = NO;
        for (int i = 0; i < self.array.count; i++) {
            switch (i) {
                case 0:
                {
                    vw.more_labelOne.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 1:
                {
                    vw.more_labelTwo.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 2:
                {
                    vw.more_labelThree.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                case 3:
                {
                    vw.more_labelFour.text = [CSStatusTool getShowUserName:self.array[i].name charNum:1];
                    break;
                }
                default:
                    break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeUserClick{
    //吊起来
    CSCmChoiceVc *vc = [CSCmChoiceVc myTableViewController];
    vc.selectArray = self.array;
    vc.delegate = self;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    CSMainTabNavigation *nc = [[CSMainTabNavigation alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
        
    }];
}

- (void)confirmClicked:(NSMutableArray<CSOneUserModel*>*)selectArray{
    // 刷起来
    self.array = selectArray;
    [self.tableView reloadData];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [self updateHeaderView];
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger iCount = 0;
    if (section == 0) {
        iCount = 2;
    }else{
        iCount = 1;
    }
    return iCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat fHeight = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            fHeight = 44;
        }else{
            fHeight = 100;
        }
    }else{
        fHeight = 64;
    }
    return fHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        if (indexPath.row == 0) {
            static NSString *identify = @"groupname";
            CSCreateGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[CSCreateGroupCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CSGroupUserShowCell *cell = [CSGroupUserShowCell tempTableViewCellWith:tableView];
            cell.delegate = self;
            cell.array = self.array;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *identify = @"uploadgroupheader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

#pragma  CSCreateGroupCellDelegate
- (void)doneGroupName:(NSString *)strName{
    self.groupName = strName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *vw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CSScreenW, 20)];
    vw.backgroundColor = [UIColor clearColor];
    return vw;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
