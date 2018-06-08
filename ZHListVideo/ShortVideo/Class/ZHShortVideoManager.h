//
//  ZHShortVideoManager.h
//  ZHListVideo
//
//  Created by Zinkham on 16/3/24.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHShortPlayerView.h"
#import <objc/runtime.h>

@interface ZHShortVideoManager : NSObject

-(instancetype)initWithIdentifier:(NSString *)ident;

-(void)addPlayerView:(ZHShortPlayerView *)view;

-(void)removePlayerView:(ZHShortPlayerView *)view;

-(void)removeAllPlayerView;

-(void)resetIJKVieoPlayWithUrl:(NSString *)url;

@property (strong, readonly)  NSString *identifier;

@property (strong, readonly) IJKAVMoviePlayerController *videoPlayer;

@end


@interface ZHShortVideoManagerDequeue : NSObject

+(ZHShortVideoManagerDequeue *)sharecInstance;

-(ZHShortVideoManager *)dequeueManagerWithIdentifier:(NSString *)ident;

-(void)addManager:(ZHShortVideoManager *)manager;

-(void)removeManagerWithIdentifier:(NSString *)identifier;

@end

