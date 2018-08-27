//
//  CSCallingChoiceUsersVC.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/14.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCallingChoiceUsersVC.h"
#import "CSCommunicationSearchView.h"
#import "CSChoiceUsersCell.h"

@interface CSCallingChoiceUsersVC ()<UITableViewDelegate,UITableViewDataSource,SSSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (nonatomic, strong) NSMutableArray<CSOneUserModel*> *selectArray;
@property (nonatomic, strong) NSMutableArray<CSOneUserModel*> *groupPeople;
@end

@implementation CSCallingChoiceUsersVC
- (IBAction)goback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)confirm:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(confirmClicked:)]) {
            [self.delegate confirmClicked:self.selectArray];
        }
    }];
}

- (NSMutableArray<CSOneUserModel*>*)selectArray{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (NSMutableArray<CSOneUserModel*>*)groupPeople{
    if (_groupPeople == nil) {
        _groupPeople = [NSMutableArray array];
    }
    return _groupPeople;
}

- (NSMutableArray<WMGroupMember*>*)joinInCallingPeople{
    if (_joinInCallingPeople == nil) {
        _joinInCallingPeople = [NSMutableArray array];
    }
    return _joinInCallingPeople;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [CSViewStyle initInputView:self.confirmBtn color:[UIColor clearColor] radiusSize:5];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    for (LMRegisterSyncgroupModel *model in [LMRegisterModle instance].syncgroupArry) {
        if (self.groupId != model.id) {
            continue;
        }
        
        for (LMRegisterSyncgroupModel *tem in model.member) {
            
            if (tem.id == [CSUrlString instance].account.sysconf.accountid) {
                continue;
            }
            
            CSOneUserModel *peo = [[CSOneUserModel alloc] init];
            peo.id = tem.id;
            peo.name = tem.name;
            [self.groupPeople addObject:peo];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(instancetype)myTableViewController
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CallingChoiceUsersVC"];
}

#pragma tableView--delegate
#pragma tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupPeople.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSOneUserModel *model = self.groupPeople[indexPath.row];
    CSChoiceUsersCell *cell = [CSChoiceUsersCell tempTableViewCellWith:tableView];
    cell.nameLabel.text = [CSStatusTool getShowUserName:model.name];
    cell.infoLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (WMGroupMember *member in self.joinInCallingPeople) {
        if (member.bIsJoinSession &&
            (member.id == model.id)) {
            cell.selectImage.image = [UIImage imageNamed:@"choice_sel_unusers"];
            return cell;
        }
    }

    for (CSOneUserModel *tem in self.selectArray) {
        if ([tem isEqual:model]) {
            cell.selectImage.image = [UIImage imageNamed:@"choice_sel_users"];
            return cell;
        }
    }
    cell.selectImage.image = [UIImage imageNamed:@"choice_users"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CSCmCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSOneUserModel *model = self.groupPeople[indexPath.row];
    model.bIsSelect = !model.bIsSelect;

    for (WMGroupMember *modelTem in self.joinInCallingPeople) {
        
        if (modelTem.id == model.id) {
            return;
        }
    }
    
    if (model.bIsSelect) {
        [self.selectArray addObject:model];
    }else{
        [self.selectArray removeObject:model];
    }
    
    [self.tableView reloadData];
    self.selectLabel.text = [NSString stringWithFormat:@"已选择:%ld人",self.selectArray.count];
}

@end
