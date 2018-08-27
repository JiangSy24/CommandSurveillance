//
//  XZPlayProgressView.m
//  PlayerTest
//
//  Created by wangwenke on 16/7/14.
//  Copyright © 2016年 wangwenke. All rights reserved.
//

#import "XZPlayProgressView.h"

@implementation XZPlayProgressView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self resetAllSubviews];
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    if (_playBtn && _currentTimeLabel) {
        CGFloat btnWidth = self.bounds.size.height - 4;
        NSString *timeString = @"00:00:00";
        CGFloat timeWidth = ceilf([timeString boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_currentTimeLabel.font} context:nil].size.width);
        _playBtn.frame = CGRectMake(10.0, 2.0, btnWidth, btnWidth);
        _currentTimeLabel.frame = CGRectMake(_playBtn.frame.origin.x + _playBtn.bounds.size.width + 5.0, 0, timeWidth, self.bounds.size.height);
        _fullBtn.frame = CGRectMake(self.bounds.size.width - _playBtn.bounds.size.width - _playBtn.frame.origin.x, _playBtn.frame.origin.y, _playBtn.bounds.size.width, _playBtn.bounds.size.height);
        _totalDurationLabel.frame = CGRectMake(_fullBtn.frame.origin.x - 5.0 - timeWidth, _currentTimeLabel.frame.origin.y, _currentTimeLabel.bounds.size.width, _currentTimeLabel.bounds.size.height);
        
        _timeIntervalProgress.bounds = CGRectMake(0, 0, self.bounds.size.width - 2 * (_currentTimeLabel.frame.origin.x + _currentTimeLabel.bounds.size.width + 5.0), 20.0);
        _timeIntervalProgress.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _progressSlider.bounds = CGRectMake(0, 0, self.bounds.size.width - 2 * (_currentTimeLabel.frame.origin.x + _currentTimeLabel.bounds.size.width + 5.0) + 3.4, 20.0);
        _progressSlider.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
//        _timeIntervalProgress.frame = CGRectMake(_currentTimeLabel.frame.origin.x + _currentTimeLabel.bounds.size.width + 5.0, self.bounds.size.height / 2.0 - 10.0, self.bounds.size.width - 2 * (_currentTimeLabel.frame.origin.x + _currentTimeLabel.bounds.size.width + 5.0), 20.0);
//        _progressSlider.frame = _timeIntervalProgress.frame;
        
    }
}

- (void)resetAllSubviews{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:_playBtn];
    [_playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    
    _currentTimeLabel = [[UILabel alloc]init];
    _currentTimeLabel.backgroundColor = [UIColor clearColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:13.0];
    _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    _currentTimeLabel.textColor = [UIColor whiteColor];
    [self addSubview:_currentTimeLabel];
    
    _timeIntervalProgress = [[UIProgressView alloc]init];
    _timeIntervalProgress.backgroundColor = [UIColor clearColor];
    _timeIntervalProgress.trackTintColor = [UIColor grayColor];
    _timeIntervalProgress.tintColor = [UIColor lightGrayColor];
    [self addSubview:_timeIntervalProgress];
    
    _progressSlider = [[UISlider alloc]init];
    _progressSlider.backgroundColor = [UIColor clearColor];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
    [_progressSlider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateHighlighted];
    _progressSlider.maximumTrackTintColor = [UIColor clearColor];
    [self addSubview:_progressSlider];
    
    _totalDurationLabel = [[UILabel alloc]init];
    _totalDurationLabel.backgroundColor = [UIColor clearColor];
    _totalDurationLabel.font = [UIFont systemFontOfSize:13.0];
    _totalDurationLabel.textAlignment = NSTextAlignmentLeft;
    _totalDurationLabel.textColor = [UIColor whiteColor];
    [self addSubview:_totalDurationLabel];
    
    _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _fullBtn.backgroundColor = [UIColor clearColor];
    [_fullBtn setImage:[UIImage imageNamed:@"icon_full"] forState:UIControlStateNormal];
    [self addSubview:_fullBtn];

}

@end
