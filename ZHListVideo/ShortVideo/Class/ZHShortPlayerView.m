//
//  ZHShortPlayerView.m
//  BaoManReader
//
//  Created by xinguang.hu on 15/3/23.
//  Copyright (c) 2015年 Baozou. All rights reserved.
//

#import "ZHShortPlayerView.h"
#import "ZHShortVideoManager.h"
#import "ZHShortControllView.h"

@interface ZHShortPlayerView()
{
    
    ZHShortControllView *controllView;
    
    ZHShortVideoManager *manager;
    
    BOOL isCurrentPlay;
    
}

@end


@implementation ZHShortPlayerView

-(void)destroy
{
    [[ZHShortVideoManagerDequeue sharecInstance] removeManagerWithIdentifier:_identifier];
    [manager removeIJKVieoPlayer];
    
}
-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
    controllView.playOrPauseBlock = nil;
}

-(instancetype)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident
{
    if (self = [super initWithFrame:frame]) {
        _videoUrl = [[NSString alloc] init];
        isCurrentPlay = NO;
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        
        _identifier = [[NSString alloc] initWithFormat:@"%@", ident];
        
        manager = [[ZHShortVideoManagerDequeue sharecInstance] dequeueManagerWithIdentifier:_identifier];
        [manager addPlayerView:self];
        
        controllView = [[ZHShortControllView alloc] initWithFrame:frame];
        __weak ZHShortPlayerView *weakSelf = self;
        controllView.playOrPauseBlock = ^{
            [weakSelf pasuseOrPlay];
            
        };
        [self addSubview:controllView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [controllView setFrame:frame];
}

//内容设置
-(void)setVideoUrl:(NSString *)sourceUrl coverUrl:(NSString *)coverUrl
{
    //来自重用cell，并且实在播放，先停止播放
    if (_videoUrl.length > 0 && isCurrentPlay) {
        [self shutDownPlay];
    }
    _videoUrl = [[NSString alloc] initWithFormat:@"%@",sourceUrl];
    [controllView setFrame:self.bounds];
    [controllView setCoverimageUrl:coverUrl];
    [controllView setControllState:ShortControllStateNormal];
}

-(void)pasuseOrPlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            if (manager.videoPlayer.currentPlaybackTime > 0) {
                if (manager.videoPlayer.isPlaying) {
                    [self pausePlay];
                } else {
                    [self resumePlay];
                }
            }
        }
    }
}

-(void)shutDownPlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            [manager.videoPlayer shutdown];
            [manager.videoPlayer.view removeFromSuperview];
        }
        [controllView setControllState:ShortControllStateNormal];
        isCurrentPlay = NO;
    }
}

-(void)pausePlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            [manager.videoPlayer pause];
        }
        [controllView setControllState:ShortControllStatePaused];
    }
}

-(void)resumePlay
{
    @synchronized(_videoUrl) {
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            [manager.videoPlayer play];
        }
        [controllView setControllState:ShortControllStatePlaying];
    }
}

-(void)play
{
    @synchronized(_videoUrl) {
        NSLog(@"---player--window = %@", NSStringFromClass([self.superview class]));
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            if (manager.videoPlayer.currentPlaybackTime <= 0) {
                [manager.videoPlayer prepareToPlay];
            } else {
                [manager.videoPlayer play];
            }
            [manager.videoPlayer.view removeFromSuperview];
            [self addSubview:manager.videoPlayer.view];
        }
        
        manager.videoPlayer.view.frame = self.bounds;
        controllView.frame = self.bounds;
        [controllView setControllState:ShortControllStateLoading];
        isCurrentPlay = YES;
    }
}

-(void)refreshControllView
{
    @synchronized(_videoUrl) {
        //保证controllView状态正确
        if ([_videoUrl isEqualToString:manager.videoPlayer.playUrl.absoluteString]) {
            //播放状态
            if (manager.videoPlayer.isPlaying) {
                
                if (controllView.controllState != ShortControllStatePlaying) {
                    [controllView setControllState:ShortControllStatePlaying];
                }
                
                return;
            }
            //加载状态
            if (manager.videoPlayer.currentPlaybackTime <= 0) {
                if (controllView.controllState != ShortControllStateLoading) {
                    [controllView setControllState:ShortControllStateLoading];
                }
                return;
            }
            //暂停状态
            if ((manager.videoPlayer.playbackState == IJKMPMoviePlaybackStatePaused)) {
                if (controllView.controllState != ShortControllStatePaused) {
                    [controllView setControllState:ShortControllStatePaused];
                }
                return;
            }
            //正常状态
            if (controllView.controllState != ShortControllStateNormal) {
                [controllView setControllState:ShortControllStateNormal];
            }
        } else {
            if (controllView.controllState != ShortControllStateNormal) {
                [controllView setControllState:ShortControllStateNormal];
            }
        }
    }
}

@end
