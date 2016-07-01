//
//  ZHShortVideoManager.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/24.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHShortVideoManager.h"

#define CenterY (32+[[UIScreen mainScreen] bounds].size.height*.5)


@interface ZHShortVideoManager()
{
    
    
    BOOL shouldCheckOnTracking;
    
    BOOL  isTracking;
    
    BOOL  isShowInWindow;
    
    NSMutableArray *dataArrray;
    
    CFRunLoopObserverRef observe;
    
    NSMutableArray *registeredNotifications;

    __weak ZHShortPlayerView *lastView;
    
}
@end

@implementation ZHShortVideoManager


-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
    [self unregisterObservers];
}

-(instancetype)initWithIdentifier:(NSString *)ident
{
    if (self = [super init]) {
        //初始化变量
        isTracking = NO;
        isShowInWindow = NO;
        shouldCheckOnTracking = NO;
        dataArrray = [[NSMutableArray alloc] init];
        _identifier = [[NSString alloc] initWithFormat:@"%@", ident];
        registeredNotifications = [[NSMutableArray alloc] init];
        
        //初始化播放器
        [self resetIJKVieoPlayWithUrl:@""];
        
        //设置监听
        [self registerObservers];
    }
    return self;
}


-(void)checkPlayState
{
    @autoreleasepool {
        
        //系统的滑动返回过程忽略,如使用的UINavigationController+FDFullscreenPopGesture,请切换为fd_fullscreenPopGestureRecognizer
        BOOL transing = NO;
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UINavigationController class]]) {
            UIGestureRecognizerState state = ((UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController).interactivePopGestureRecognizer.state;
            
            transing =  (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged);
        }
        if (transing) {
            return;
        }
        
        //页面切换后，不可见
        ZHShortPlayerView *chekView = dataArrray.firstObject;
        BOOL showInWindow = chekView.window == nil ? NO : YES;
        
        if (isShowInWindow && !showInWindow) {
            [self becomeInvisible];
        }
        if (!isShowInWindow && showInWindow) {
            [self becomeVisible];
        }
        isShowInWindow = showInWindow;
        
        if (!isShowInWindow) {
            //NSLog(@"%@已经切换到可见，直接返回", _identifier);
            return;
        }
        
        BOOL tracking = [NSRunLoop currentRunLoop].currentMode == UITrackingRunLoopMode;
        if (tracking && !isTracking) {
            [self beginTrack];
        }
        if (tracking) {
            [self onTracking];
        }
        if (!tracking && isTracking) {
            //添加延时，避免在setVideoUrl
            [self endTrack];
        }
        isTracking = tracking;
        
    }
}

-(void)beginTrack
{
    //开始滑动
    shouldCheckOnTracking = YES;
    NSLog(@"%@  beginTrack", _identifier);
}


-(void)onTracking
{
    //滑动过程
    
    if (shouldCheckOnTracking && ![self isDisplayedInScreen:lastView]) {
        [lastView shutDownPlay];
        shouldCheckOnTracking = NO;
    }
    NSLog(@"%@  onTracking", _identifier);
}

-(void)endTrack
{
    //滑动结束
    shouldCheckOnTracking = NO;
    ZHShortPlayerView *pview = [self getCurrentShouldPlayView];
    if (pview) {
        if (lastView && lastView != pview) {
            [lastView shutDownPlay];
        }
        [self resetIJKVieoPlayWithUrl:pview.videoUrl];
        [pview play];
        lastView = pview;
    }
    NSLog(@"%@  endTrack", _identifier);
}

-(void)becomeVisible
{
    //切换到可见
    [self endTrack];
    NSLog(@"%@  becomeVisible", _identifier);
}

-(void)becomeInvisible
{
    //切换到不可见
    [_videoPlayer shutdown];
    NSLog(@"%@  becomeInvisible", _identifier);
}

-(void)didScrollToTop:(NSNotification *)notification
{
    [self endTrack];
    
}


-(void)resetIJKVieoPlayWithUrl:(NSString *)url
{

    @autoreleasepool {
        if (_videoPlayer == nil || _videoPlayer.view.superview == nil
            || ![_videoPlayer.playUrl.absoluteString isEqualToString:url] || _videoPlayer.isShutdown) {
            [_videoPlayer shutdown];
            _videoPlayer = [[IJKAVMoviePlayerController alloc] initWithContentURLString:url];
            _videoPlayer.view.userInteractionEnabled = NO;
            _videoPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _videoPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
            _videoPlayer.view.autoresizesSubviews = YES;
            _videoPlayer.shouldAutoplay = YES;
            _videoPlayer.repeat = YES;
            [_videoPlayer setPauseInBackground:YES];
            _videoPlayer.view.backgroundColor = [UIColor clearColor];
            for(UIView *aSubView in _videoPlayer.view.subviews) {
                aSubView.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

-(ZHShortPlayerView *)getCurrentShouldPlayView
{
    ZHShortPlayerView *pview = nil;
    CGPoint lastPos =CGPointZero;
    for (ZHShortPlayerView *view in dataArrray) {
        if ([self isDisplayedInScreen:view]) {
            CGPoint pos = [view convertPoint:view.center toView:[UIApplication sharedApplication].keyWindow];
            if (fabs(lastPos.y-CenterY) > fabs(pos.y-CenterY)) {
                lastPos = pos;
                pview = view;
            }
        }
    }
    return pview;
}

// 判断View是否显示在屏幕上
-(BOOL)isDisplayedInScreen:(UIView *)view
{
    
    if (view.window == nil) {
        return NO;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGRect rect = [view convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    
    if (view.hidden) {
        return NO;
    }
    
    if (view.superview == nil) {
        return NO;
    }
    
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  NO;
    }
    
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return YES;
}


- (void)registerObservers
{
    //监听应用器状态
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [registeredNotifications addObject:UIApplicationWillEnterForegroundNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [registeredNotifications addObject:UIApplicationDidBecomeActiveNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [registeredNotifications addObject:UIApplicationWillResignActiveNotification];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [registeredNotifications addObject:UIApplicationDidEnterBackgroundNotification];
    

    //监听滚动到顶部
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didScrollToTop:)
                                                 name:ZHScrollToTopNotification
                                               object:nil];
    [registeredNotifications addObject:ZHScrollToTopNotification];
    
    
    //监听滑动状态变化
    __weak typeof(self) weakSelf = self;
    observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        [weakSelf checkPlayState];
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopCommonModes);
    CFRelease(observe);
    
}

- (void)unregisterObservers
{
    for (NSString *name in registeredNotifications) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:name
                                                      object:nil];
    }
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopCommonModes);
}


- (void)applicationWillEnterForeground
{
    NSLog(@"ZHShortVideoManager:applicationWillEnterForeground: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidBecomeActive
{
    [self.videoPlayer play];
    for (ZHShortPlayerView *view in dataArrray) {
        [view refreshControllView];
    }
    NSLog(@"ZHShortVideoManager:applicationDidBecomeActive: %d\n", (int)[UIApplication sharedApplication].applicationState);

}

- (void)applicationWillResignActive
{

    NSLog(@"ZHShortVideoManager:applicationWillResignActive: %d\n", (int)[UIApplication sharedApplication].applicationState);
}

- (void)applicationDidEnterBackground
{
    NSLog(@"ZHShortVideoManager:applicationDidEnterBackground: %d\n", (int)[UIApplication sharedApplication].applicationState);

}

-(void)addPlayerView:(ZHShortPlayerView *)view
{
    for (ZHShortPlayerView *item in dataArrray) {
        if ([view.videoUrl isEqualToString:item.videoUrl]) {
            [dataArrray removeObject:item];
            break;
        }
    }
    [dataArrray addObject:view];
}

-(void)removePlayerView:(ZHShortPlayerView *)view
{
    [dataArrray removeObject:view];
    
    if (dataArrray.count <= 0) {
        [[ZHShortVideoManagerDequeue sharecInstance] removeManagerWithIdentifier:view.identifier];
    }
}

-(void)removeAllPlayerView
{
    
    [dataArrray removeAllObjects];
}

@end




@implementation ZHShortVideoManagerDequeue

static NSMutableDictionary *resumeManagerData;

-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
}

+(ZHShortVideoManagerDequeue *)sharecInstance
{
    
    static ZHShortVideoManagerDequeue *sharedClient = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[ZHShortVideoManagerDequeue alloc] init];
        resumeManagerData =  [[NSMutableDictionary alloc] init];
        
    });
    return sharedClient;
}

-(ZHShortVideoManager *)dequeueManagerWithIdentifier:(NSString *)identifier
{
    id tmpValue = [resumeManagerData objectForKey:identifier];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        ZHShortVideoManager *manager = [[ZHShortVideoManager alloc] initWithIdentifier:identifier];
        [self addManager:manager];
        return manager;
    }
    return tmpValue;
}

-(void)addManager:(ZHShortVideoManager *)manaer
{
    id tmpValue = [resumeManagerData objectForKey:manaer.identifier];
    
    if (tmpValue == nil || tmpValue == [NSNull null])
    {
        [resumeManagerData setObject:manaer forKey:manaer.identifier];
    }
}

-(void)removeManagerWithIdentifier:(NSString *)identifier
{
    id tmpValue = [resumeManagerData objectForKey:identifier];
    
    if (tmpValue != nil && tmpValue != [NSNull null])
    {
        [resumeManagerData removeObjectForKey:identifier];
        [((ZHShortVideoManager *)tmpValue) removeAllPlayerView];
    }
}

@end
