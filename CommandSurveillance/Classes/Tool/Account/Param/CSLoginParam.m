//
//  CSLoginParam.m
//  CloudSurveillance
//
//  Created by liangcong on 16/11/4.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import "CSLoginParam.h"

@implementation CSLoginParam
// 实现这个方法，就会自动把数组中的字典转换成对应的模型
@end
@implementation CSUsersModel
+ (NSDictionary *)objectClassInArray
{
    return @{@"accounts":[CSOneUserModel class]};
}
+ (instancetype)instance
{
    //    static dispatch_once_t  onceToken;
    static CSUsersModel* model = nil;
    if (model == nil) {
        model = [[[self class] alloc] init];
    }
    return model;
}

- (NSMutableDictionary*)dicAccounts{
    if (_dicAccounts == nil) {
        _dicAccounts = [NSMutableDictionary dictionary];
    }
    return _dicAccounts;
}

- (NSMutableDictionary*)dicPreAccount{//CSOneUserModel
    if (_dicPreAccount == nil) {
        _dicPreAccount = [NSMutableDictionary dictionary];
    }
    return _dicPreAccount;
}

- (void)setAccounts:(NSMutableArray<CSOneUserModel *> *)accounts{
    _accounts = accounts;
}

- (void)makeData{
    //遍历
    for (CSOneUserModel *model in self.accounts) {
        [self.dicPreAccount setObject:model forKey:[NSString stringWithFormat:@"%d",model.id]];
        NSMutableArray *letterArr = [self.dicAccounts objectForKey:model.strLetter];
        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [self.dicAccounts setObject:letterArr forKey:model.strLetter];
        }
        
        // 除掉自己，删掉自己，排除自己
        if (model.id == [CSUrlString instance].account.sysconf.accountid) {
            continue;
        }
        //将新数据放到数组里
        [letterArr addObject:model];
    }
    
    //获得cityDict字典里的所有key值，
    NSArray *keys = [self.dicAccounts allKeys];
    //打印
    //    NSLog(@"keys = %@",[keys sortedArrayUsingSelector:@selector(compare:)]);
    //按升序进行排序（A B C D……）
    NSArray *keysss = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *nsArray = [NSMutableArray array];
    for (NSString *tem in keysss)
    {
        if ([tem isEqualToString:@"#"]) {
            continue;
        }
        [nsArray addObject:tem];
    }
    
    if ((keysss.count > 0) &&
        [keysss[0] isEqualToString:@"#"]) {
        [nsArray addObject:@"#"];
    }
    self.arrySortedKeys = nsArray;
}

+ (NSMutableArray*)makeArrayData:(NSMutableArray<CSOneUserModel*>*)array toDic:(NSMutableDictionary*)dicAccouts{
    //遍历
    for (CSOneUserModel *model in array) {
//        [self.dicPreAccount setObject:model forKey:[NSString stringWithFormat:@"%d",model.id]];
        NSMutableArray *letterArr = [dicAccouts objectForKey:model.strLetter];
        //判断数组里是否有元素，如果为nil，则实例化该数组，并在cityDict字典中插入一条新的数据
        if (letterArr == nil) {
            letterArr = [[NSMutableArray alloc] init];
            [dicAccouts setObject:letterArr forKey:model.strLetter];
        }
        
        // 除掉自己，删掉自己，排除自己
        if (model.id == [CSUrlString instance].account.sysconf.accountid) {
            continue;
        }
        //将新数据放到数组里
        [letterArr addObject:model];
    }
    
    //获得cityDict字典里的所有key值，
    NSArray *keys = [dicAccouts allKeys];
    //打印
    //    NSLog(@"keys = %@",[keys sortedArrayUsingSelector:@selector(compare:)]);
    //按升序进行排序（A B C D……）
    NSArray *keysss = [keys sortedArrayUsingSelector:@selector(compare:)];
    NSMutableArray *nsArray = [NSMutableArray array];
    for (NSString *tem in keysss)
    {
        if ([tem isEqualToString:@"#"]) {
            continue;
        }
        [nsArray addObject:tem];
    }
    
    if ((keysss.count > 0) &&
        [keysss[0] isEqualToString:@"#"]) {
        [nsArray addObject:@"#"];
    }
    return nsArray;
}
@end

@implementation CSOneUserModel

- (NSString*)strLetter{
    self.strPinYin = [CSStatusTool transform:self.name];
    //获取首字,uppercaseString是将首字母转换成大写
    if (self.strPinYin.length > 0) {
        NSString *letterStr = [[self.strPinYin substringWithRange:NSMakeRange(0, 1)] uppercaseString];
        _strLetter = letterStr;
    }else{
        _strLetter = @"#";
    }
    return _strLetter;
}

- (NSString*)name{
    if (_name != nil) {
        _name = [CSStatusTool decodeString:_name];
    }
    return _name;
}
@end
