//
//  ZHShortControllView.h
//  ZHListVideo
//
//  Created by Zinkham on 16/3/24.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShortControllState) {
    ShortControllStateNormal,
    ShortControllStateLoading,
    ShortControllStatePlaying,
    ShortControllStatePaused,
};

@interface ZHShortControllView : UIView

-(void)setCoverimageUrl:(NSString *)url;

@property (copy, nonatomic) void (^playOrPauseBlock)(void);

@property (assign, nonatomic) ShortControllState controllState;

@end
