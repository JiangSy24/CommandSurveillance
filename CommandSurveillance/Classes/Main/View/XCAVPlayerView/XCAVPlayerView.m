//
//  XCAVPlayerView.m
//  PlayerTest
//
//  Created by wangwenke on 16/7/13.
//  Copyright © 2016年 wangwenke. All rights reserved.
//

#import "XCAVPlayerView.h"
#import "XZPlayProgressView.h"
#import <AVFoundation/AVFoundation.h>

#define Bottom_Height  50.f//(self.bounds.size.height * 0.18)
@interface XCAVPlayerView()

@property (nonatomic, strong) AVPlayerLayer           *avPlayerLayer;
@property (nonatomic, strong) AVPlayer                *avPlayer;
@property (nonatomic, strong) AVPlayerItem            *playerItem;
@property (nonatomic, strong) XZPlayProgressView      *progressView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIButton                *resumeBtn;
@property (nonatomic, strong) UIView                  *xzSuperView;
@property (nonatomic, assign) BOOL                    canEditProgressView;
@property (nonatomic, assign) BOOL                    isDragSlider;

@property (nonatomic, strong) AVPlayerItemVideoOutput   *playerItemVideoOutput;

@property (nonatomic, strong) UIView                    *bottomProgressView;      //  底部进度条

@property (nonatomic, strong) UIView                    *bottomSelect;          // 底部进度条
@end

@implementation XCAVPlayerView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setVolum];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setVolum];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setVolum];
    }
    return self;
}

- (UIActivityIndicatorView *)activityView{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc]init];
        _activityView.bounds = self.bounds;
        _activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [_activityView stopAnimating];
        _activityView.hidesWhenStopped = YES;
        _activityView.userInteractionEnabled = NO;
        [self addSubview:_activityView];
    }
    return _activityView;
}

- (UIImage*)snap{
    //    AVPlayerItemVideoOutput的初始化：
    //    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:nil];
    //    self.playerItemVideoOutput = [[AVPlayerItemVideoOutput alloc] init];
    //    [item addOutput:self.playerItemVideoOutput];
//    CMTime itemTimeT = [_playerItemVideoOutput itemTimeForHostTime:CACurrentMediaTime()];
//    if ([_playerItemVideoOutput hasNewPixelBufferForItemTime:itemTimeT]) {
//        CVPixelBufferRef pixelBuffer = [_playerItemVideoOutput copyPixelBufferForItemTime:itemTimeT itemTimeForDisplay:nil];
//        CIImage *image = [CIImage imageWithCVPixelBuffer:pixelBuffer];
//        // 利用 CIFilter 处理 CIImage
//        CVPixelBufferRelease(pixelBuffer);
//    }
    //    对正在播放的视频流截图取帧：
    CMTime itemTime = self.playerItem.currentTime;
    CVPixelBufferRef pixelBuffer = NULL;
    if ([_playerItemVideoOutput hasNewPixelBufferForItemTime:itemTime]) {
        pixelBuffer = [_playerItemVideoOutput copyPixelBufferForItemTime:itemTime itemTimeForDisplay:nil];
    }
    
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];

    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext
                             createCGImage:ciImage
                             fromRect:CGRectMake(0, 0,
                                                 CVPixelBufferGetWidth(pixelBuffer),
                                                 CVPixelBufferGetHeight(pixelBuffer))];
    
    UIImage *frameImg = [UIImage imageWithCGImage:videoImage];
    CGImageRelease(videoImage);
    // 判断视频旋转角度，对图片做旋转处理
    NSUInteger rotate = [self degressFromVideoFileWithURL:self.playerUrl];
    AVAsset *asset = [AVAsset assetWithURL:self.playerUrl];
    CGSize videoSize = asset.naturalSize;
    if ((videoSize.height < videoSize.width)&&((rotate == 90)||(rotate == 270))) {
        // 竖着的
        frameImg = [UIImage image:frameImg rotation:rotate == 90 ? UIImageOrientationRight : UIImageOrientationLeft];
    }
    
    if ((videoSize.height < videoSize.width)&&((rotate == 180)||(rotate == 0))) {
        frameImg = [UIImage image:frameImg rotation:rotate == 180 ? UIImageOrientationDown : UIImageOrientationUp];
    }
    return frameImg;
}

- (NSUInteger)degressFromVideoFileWithURL:(NSURL *)url
{
    NSUInteger degress = 0;
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGAffineTransform t = videoTrack.preferredTransform;
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0){
            // Portrait
            degress = 90;
        }else if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0){
            // PortraitUpsideDown
            degress = 270;
        }else if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0){
            // LandscapeRight
            degress = 0;
        }else if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0){
            // LandscapeLeft
            degress = 180;
        }
    }
    return degress;
}

- (UIView*)bottomProgressView{
    if (_bottomProgressView == nil) {
        _bottomProgressView = [[UIView alloc] init];
        _bottomProgressView.frame = CGRectMake(0, self.bounds.size.height - 3, self.bounds.size.width, 3);
        _bottomProgressView.backgroundColor = CSUIColor(230, 230, 230);
        [self addSubview:_bottomProgressView];
    }
    return _bottomProgressView;
}

- (UIView*)bottomSelect{
    if (_bottomSelect == nil) {
        _bottomSelect = [[UIView alloc] init];
        _bottomSelect.backgroundColor = CSColorBtnBule;
        [self.bottomProgressView addSubview:_bottomSelect];
    }
    return _bottomSelect;
}

- (XZPlayProgressView *)progressView{
    if (!_progressView) {
        [self bindTap];
        _progressView = [[XZPlayProgressView alloc]init];
        _progressView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        [_progressView.playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.fullBtn addTarget:self action:@selector(fullBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_progressView.progressSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [_progressView.progressSlider addTarget:self action:@selector(sliderCancled:) forControlEvents:UIControlEventTouchCancel];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        [_progressView.progressSlider addTarget:self action:@selector(sliderTouchOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:_progressView];
    }
    return _progressView;
}

- (UIButton *)resumeBtn{
    if (!_resumeBtn) {
        _resumeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resumeBtn.hidden = YES;
        _resumeBtn.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
        _resumeBtn.frame = self.bounds;
        [_resumeBtn setImage:[UIImage imageNamed:@"icon_repeat_video"] forState:UIControlStateNormal];
        [_resumeBtn setImageEdgeInsets:UIEdgeInsetsMake(self.bounds.size.height / 2.0 - 37.0, self.bounds.size.width / 2.0 - 25.0, self.bounds.size.height / 2.0 - 37.0, self.bounds.size.width / 2.0 - 25.0)];
        [_resumeBtn addTarget:self action:@selector(resumeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_resumeBtn];
    }
    [self bringSubviewToFront:_resumeBtn];
    return _resumeBtn;
}

- (void)setVolum{
    self.clipsToBounds = YES;
    self.isShowBottomProgressView = YES;
    self.isShowResumViewAtPlayEnd = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback
             withOptions:AVAudioSessionCategoryOptionMixWithOthers
                   error:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterbackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)setPlayerUrl:(NSURL *)playerUrl{
    if (playerUrl) {
        _playerUrl = playerUrl;
        if (_avPlayer) {
            [_avPlayer pause];
            [_avPlayerLayer removeFromSuperlayer];
            [self.playerItem removeObserver:self forKeyPath:@"status"];
            [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
            _totalDuration = 0.0f;
            _timeInterval = 0.0f;
            _currentPlayTime = 0.0f;
        }
        self.canEditProgressView = YES;
//        [self hiddenProgressView:NO];
        self.canEditProgressView = NO;
        [self.activityView startAnimating];
        _playerItem = [[AVPlayerItem alloc]initWithURL:playerUrl];
        
        self.playerItemVideoOutput = [[AVPlayerItemVideoOutput alloc] init];
        [_playerItem addOutput:self.playerItemVideoOutput];
        
        _avPlayer = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
        _avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
        _avPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [(AVPlayerLayer *)self.layer addSublayer:_avPlayerLayer];
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];//监听status属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];//监听loadedTimeRanges属性
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
        [self currentXCPlayerTime];
        
        [self bringSubviewToFront:self.progressView];
        [self bringSubviewToFront:self.activityView];
        [self bringSubviewToFront:self.bottomProgressView];
        
        _avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        NSLog(@"setPlayerUrl");
    }
}

- (void)setIsShowBottomProgressView:(BOOL)isShowBottomProgressView{
    _isShowBottomProgressView = isShowBottomProgressView;
    self.progressView.hidden = !isShowBottomProgressView;
    self.bottomProgressView.hidden = isShowBottomProgressView;
}

- (void)setIsShowResumViewAtPlayEnd:(BOOL)isShowResumViewAtPlayEnd{
    _isShowResumViewAtPlayEnd = isShowResumViewAtPlayEnd;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_avPlayerLayer) {
        _avPlayerLayer.frame = self.bounds;
    }
    CGRect frame = self.progressView.frame;
    self.progressView.frame = CGRectMake(frame.origin.x, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
    self.activityView.bounds = self.bounds;
    self.activityView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.resumeBtn.frame = self.bounds;
}

/** 播放 */
- (void)play{
    if (_avPlayer) {
        [_avPlayer play];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
        [self performSelector:@selector(currentXCPlayerTime) withObject:nil afterDelay:0.5];
    }
    
    if (_isShowResumViewAtPlayEnd) {
        self.resumeBtn.hidden = _isShowResumViewAtPlayEnd;
    }
    [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
}

/** 暂停 */
- (void)pause{
    if (_avPlayer) {
        [_avPlayer pause];
    }
    [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
}

/** 重新开始 */
- (void)resume{
    [self.avPlayer seekToTime:kCMTimeZero];
    if (self.avPlayer.rate == 0.0) {
        [self.avPlayer play];
    }
}

/**
 *  停止
 */
- (void)stop{

    if (self.playerItem && _avPlayer) {
        [_avPlayer pause];
        [_avPlayerLayer removeFromSuperlayer];

        _totalDuration = 0.0f;
        _timeInterval = 0.0f;
        _currentPlayTime = 0.0f;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        _avPlayer = nil;
    }
}

/** 播放状态 */
- (BOOL)isPlaying{
    if (self.avPlayer.rate == 0) {
        return NO;
    }
    return YES;
}

- (void)playBtnClicked:(UIButton *)sender{
    if (self.avPlayer.rate != 0) {
        [self pause];
    }else{
        [self play];
    }
}

- (void)resumeBtnClicked:(UIButton *)sender{
    [self resume];
    sender.hidden = YES;
}

- (void)sliderTouchDown:(UISlider *)sender{
    _isDragSlider = YES;
}
- (void)sliderValueChanged:(UISlider *)sender{
    _isDragSlider = YES;
    self.progressView.currentTimeLabel.text = [self convertTimeToString:self.progressView.progressSlider.value];
}
- (void)sliderCancled:(UISlider *)sender{
    _isDragSlider = NO;
}
- (void)sliderTouchInside:(UISlider *)sender{
    [self seekToTime:self.progressView.progressSlider.value];
    _isDragSlider = NO;
}
- (void)sliderTouchOutside:(UISlider *)sender{
    _isDragSlider = NO;
}

#pragma mark----屏幕手动旋转
- (void)fullBtnClicked:(UIButton *)sender{
    
    // 加菜
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreen)]) {
        // 搞一手 全屏
        [self.delegate fullScreen];
        return;
    }
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationLandscapeRight;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else if (orientation  == UIInterfaceOrientationLandscapeLeft){
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else if (orientation  == UIInterfaceOrientationPortraitUpsideDown){
        
    }else if (orientation  == UIInterfaceOrientationLandscapeRight){
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
}

/** 播放时间 00:00:00 */
- (NSString *)convertTimeToString:(CGFloat)second{
    NSDate *pastDate = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *timeString = [formatter stringFromDate:pastDate];

    CMTime itemTimeT = [_playerItemVideoOutput itemTimeForHostTime:CACurrentMediaTime()];
    // 解决照相问题
    if (![_playerItemVideoOutput hasNewPixelBufferForItemTime:itemTimeT]) {
        // 删除，重加
        [self.playerItem removeOutput:_playerItemVideoOutput];
        self.playerItemVideoOutput = [[AVPlayerItemVideoOutput alloc] init];
        [self.playerItem addOutput:self.playerItemVideoOutput];
    }
    
    return timeString;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"XCPlayerStatusReadyToPlay");
            self.totalDuration = floorf(CMTimeGetSeconds(self.playerItem.duration));
            self.progressView.totalDurationLabel.text = [self convertTimeToString:self.totalDuration];
            self.progressView.progressSlider.maximumValue = self.totalDuration;
            self.progressView.progressSlider.minimumValue = 0;
            self.canEditProgressView = YES;
            [self showProgressView:NO];
            [self.activityView stopAnimating];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
//                [self.delegate xcAVPlayerView:self reloadStatuesChanged:XCPlayerStatusReadyToPlay];
//            }
        }else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"XCPlayerStatusFailed : error:%@",self.avPlayer.error.domain);
            [self.activityView stopAnimating];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
//                [self.delegate xcAVPlayerView:self reloadStatuesChanged:XCPlayerStatusFailed];
//            }
        }else if ([playerItem status] == AVPlayerStatusUnknown){
            NSLog(@"XCPlayerStatusUnknown");
            [self.activityView stopAnimating];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
//                [self.delegate xcAVPlayerView:self reloadStatuesChanged:XCPlayerStatusUnknown];
//            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];//计算缓冲进度
        self.timeInterval = timeInterval;
        self.progressView.timeIntervalProgress.progress = self.timeInterval / self.totalDuration;
        NSLog(@"Time Interval:%f",timeInterval);
    }
}

- (void)currentXCPlayerTime{
    self.currentPlayTime = floorf(CMTimeGetSeconds(self.playerItem.currentTime));
    if (self.currentPlayTime < 0) {
        self.currentPlayTime = 0.0;
    }
    if (self.avPlayer.rate != 0) {
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
    }else{
        [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    }
    if (!_isDragSlider) {
        self.progressView.progressSlider.value = self.currentPlayTime;
        self.progressView.currentTimeLabel.text = [self convertTimeToString:self.currentPlayTime];
        
        // 做进度条处理
        if (self.totalDuration > 0) {
            CGFloat fpre = self.frame.size.width / self.totalDuration;
            self.bottomSelect.frame = CGRectMake(0, 0, self.currentPlayTime * fpre, self.bottomProgressView.height);
        }
    }
//    NSLog(@"current playTime:%f－－status:%d",self.currentPlayTime,self.playerItem.status);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(currentXCPlayerTime) object:nil];
    [self performSelector:@selector(currentXCPlayerTime) withObject:nil afterDelay:0.5];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.avPlayer currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/** 拉动进度条 */
- (void)seekToTime:(CGFloat)seekTime{
    if (_avPlayer) {
        CMTime time = CMTimeMake(seekTime * self.playerItem.currentTime.timescale, self.playerItem.currentTime.timescale);
        [_avPlayer seekToTime:time];
    }
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    if (_isShowBottomProgressView) {
//        if ([self.progressView isHidden]) {
//            [self showProgressView:YES];
//        }else{
//            [self hiddenProgressView:YES];
//        }
//    }
//}
/**
 *  绑定点按手势
 *
 *  @param imgVCustom 绑定到图片视图对象实例
 */
- (void)bindTap {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handleTap:)];
    //使用一根手指双击时，才触发点按手势识别器
    recognizer.numberOfTapsRequired = 1;
    recognizer.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:recognizer];
}

/**
 *  处理点按手势
 *
 *  @param recognizer 点按手势识别器对象实例
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint pos = [recognizer locationInView:self];
    if ((_progressView.hidden == NO && CGRectContainsPoint(_progressView.frame, pos))) {
        return;
    }

    if (_isShowBottomProgressView) {
        if ([self.progressView isHidden]) {
            [self showProgressView:YES];
        }else{
            [self hiddenProgressView:YES];
        }
    }
}


#pragma mark---bottom progress view
- (void)hiddenProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
            self.bottomProgressView.frame = CGRectMake(0, self.bounds.size.height - 3, self.bounds.size.width, 3);
        } completion:^(BOOL finished) {
            self.progressView.hidden = YES;
            self.bottomProgressView.hidden = NO;
            self.canEditProgressView = YES;
        }];
    }else{
        self.progressView.hidden = YES;
        self.bottomProgressView.hidden = NO;
        self.canEditProgressView = YES;
        self.progressView.frame = CGRectMake(0, self.bounds.size.height, self.progressView.bounds.size.width, self.progressView.bounds.size.height);
        self.bottomProgressView.frame = CGRectMake(0, self.bounds.size.height - 3, self.bounds.size.width, 3);
    }

}

- (void)showProgressView:(BOOL)animate{
    if (!_canEditProgressView) {
        return;
    }
    _canEditProgressView = NO;
    self.progressView.hidden = NO;
    self.bottomProgressView.hidden = YES;
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
            self.bottomProgressView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 3);
        } completion:^(BOOL finished) {
            self.canEditProgressView = YES;
        }];
    }else{
        self.progressView.frame = CGRectMake(0, self.bounds.size.height - Bottom_Height, self.bounds.size.width, Bottom_Height);
        self.bottomProgressView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 3);
        self.canEditProgressView = YES;
    }
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenProgressView:) object:self];
//    [self performSelector:@selector(hiddenProgressView:) withObject:self afterDelay:3.0];
}

#pragma notification
- (void)playerPlayToEnd:(NSNotification *)notification{
    NSLog(@"play end");
    [self pause];
    [self.avPlayer seekToTime:kCMTimeZero];
    [self.progressView.playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    self.canEditProgressView = YES;
    [self hiddenProgressView:NO];
    self.resumeBtn.hidden = !_isShowResumViewAtPlayEnd;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(xcAVPlayerView:reloadStatuesChanged:)]) {
//        [self.delegate xcAVPlayerView:self reloadStatuesChanged:XCPlayerStatusPlayEnd];
//    }
}

- (void)applicationEnterbackground:(NSNotification *)notification{
    if ([self isPlaying]) {
        [self pause];
    }
}

- (void)dealloc{
    
}

- (void)clearAll{
    
    if (_avPlayer && self.playerItem) {
        NSLog(@"clearAll");
        [_avPlayer pause];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.playerItem cancelPendingSeeks];
        [self.playerItem.asset cancelLoading];
        [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
        [_avPlayerLayer removeFromSuperlayer];
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        _totalDuration = 0.0f;
        _timeInterval = 0.0f;
        _currentPlayTime = 0.0f;
        _avPlayer = nil;
    }
}

@end
