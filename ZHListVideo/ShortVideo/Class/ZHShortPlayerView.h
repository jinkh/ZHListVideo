//
//  ZHShortPlayerView.h
//  BaoManReader
//
//  Created by xinguang.hu on 15/3/23.
//  Copyright (c) 2015年 Baozou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKMediaPlayback.h"
#import "IJKMPMoviePlayerController.h"
#import "IJKAVMoviePlayerController.h"

@interface ZHShortPlayerView : UIImageView


-(id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)ident;

-(void)setVideoUrl:(NSString *)sourceUrl coverUrl:(NSString *)coverUrl;

-(void)play;

-(void)stopPlay;

-(void)shutDownPlay;

-(void)resumePlay;

-(void)pausePlay;

-(void)destroy;

-(void)refreshControllView;

@property (strong, readonly)  NSString *identifier;

@property (strong, readonly)  NSString *videoUrl;

@end

