//
//  MainViewController.h
//  GDMapPlaceAroundDemo
//
//  Created by Mr.JJ on 16/6/14.
//  Copyright © 2016年 Mr.JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LocationModel : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *address;
///纬度（垂直方向）
@property (nonatomic, assign) CGFloat latitude;
///经度（水平方向）
@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) UIImage *snapImage;
@end

@protocol MainViewControllerDelegate <NSObject>
- (void)sendLocation:(LocationModel*)model;
@end

@interface MainViewController : UIViewController
@property (nonatomic, weak) id<MainViewControllerDelegate> delegate;
@end
