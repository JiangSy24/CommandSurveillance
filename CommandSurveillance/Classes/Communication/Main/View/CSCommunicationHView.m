//
//  CSCommunicationHView.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/23.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "CSCommunicationHView.h"
@interface CSCommunicationHView()<SSSearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *logoImage;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UIView *searchViewBox;

@end
@implementation CSCommunicationHView

+ (instancetype)appInfoView
{
    //加载xib中得view
    CSCommunicationHView *subView = [[[NSBundle mainBundle] loadNibNamed:@"CSCommunicationHView" owner:self options:nil] lastObject];
    return subView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    NSLog(@"%s",__func__);
    [self drawAllControl];
}

- (void)drawAllControl{

    [CSViewStyle initInputViewRound:self.logoImage];
    UITapGestureRecognizer *tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickgroup)];
    [self.groupView addGestureRecognizer:tapGesturRecognizer];

    SSSearchBar *sss = [[SSSearchBar alloc]initWithFrame:CGRectMake(0, 0, CSScreenW - 30, 30)];
    sss.centerY = self.searchViewBox.height / 2;
    sss.centerX = CSScreenW / 2;
    [self.searchViewBox addSubview:sss];
    self.searchBar = sss;
    self.searchBar.cancelButtonHidden = YES;
    self.searchBar.placeholder = NSLocalizedString(@"输入设备名称", nil);
    self.searchBar.delegate = self;
}

- (void)clickgroup{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickGroupView)]) {
        [self.delegate clickGroupView];
    }
}

#pragma mark - SSSearchBarDelegate
- (void)searchBarCancelButtonClicked:(SSSearchBar *)searchBar {
    searchBar.text = @"";
    [self filterTableViewWithText:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(SSSearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(SSSearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterTableViewWithText:searchText];
}

- (void)filterTableViewWithText:(NSString *)searchText {
    BOOL isSearch = YES;//有编辑内容时为YES
    if (searchText.length <= 0) {
        isSearch = NO;//被清空时为NO
    }
//    [self.listArray removeAllObjects];
//    NSString *searchStr = self.searchBar.text;
//    if (searchStr.length > 0) {
//
//        UTPinYinHelper *pinYinHelper = [UTPinYinHelper sharedPinYinHelper];
//        for (id obj in [VSDataCache sharedInstance].dicResDevDic) {
//            NSArray *temArray = [[VSDataCache sharedInstance].dicResDevDic objectForKey:obj];
//            for (VSResListModel *listModel in temArray) {
//                if (![pinYinHelper isString:listModel.name MatchsKey:searchStr IgnorCase:YES]) {
//                    continue;
//                }
//                [self.listArray addObject:listModel];
//            }
//        }
//
//        [self.nodeTableView reloadData];
//
//    }else{
//        [self setScrollData:@"资源列表" parentId:0];
//        self.curParentId = 0;
//        [self makeCurArray];
//        [self.nodeTableView reloadData];
//    }
}
@end
