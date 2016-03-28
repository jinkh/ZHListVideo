//
//  ZHShortControllView.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/24.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ZHShortControllView.h"

@interface ZHShortControllView()
{
    
    UIImageView *coverImageView;
    UIImageView *indictorImage;
    UIView *coverMask;
    UIActivityIndicatorView *loadingIndicator;
    UIButton *tapBtn;
    
}

@end


@implementation ZHShortControllView


-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
}


-(instancetype)init
{
    if (self = [self initWithFrame:CGRectZero]) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        coverImageView = [[UIImageView alloc] initWithFrame:frame];
        coverImageView.backgroundColor = [UIColor clearColor];
        coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:coverImageView];
        
        coverMask = [[UIView alloc] initWithFrame:coverImageView.bounds];
        coverMask.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.12];
        coverMask.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:coverMask];
        
        indictorImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play_btn_icon"]];
        indictorImage.hidden = NO;
        indictorImage.frame = CGRectMake(self.frame.size.width-30, self.frame.size.height-35, 20, 20);
        indictorImage.backgroundColor = [UIColor clearColor];
        [self addSubview:indictorImage];
        
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.frame = CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 50, 50);
        loadingIndicator.hidesWhenStopped = YES;
        [self addSubview:loadingIndicator];
        
        
        tapBtn = [[UIButton alloc] initWithFrame:frame];
        tapBtn.backgroundColor = [UIColor clearColor];
        [tapBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tapBtn];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    coverImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    coverMask.frame = coverImageView.bounds;
    indictorImage.frame = CGRectMake(frame.size.width-30, frame.size.height-35, 20, 20);
    tapBtn.frame = coverImageView.bounds;
    loadingIndicator.frame =  CGRectMake(self.frame.size.width-50, self.frame.size.height-50, 50, 50);
}

-(void)setCoverimageUrl:(NSString *)url
{
    //设置封面图
}

-(void)setControllState:(ShortControllState)state
{
    _controllState = state;
    if (state == ShortControllStateNormal) {
        coverImageView.hidden = NO;
        [loadingIndicator stopAnimating];
        indictorImage.hidden = NO;
        coverMask.hidden = NO;
        [self.superview bringSubviewToFront:self];
    } else if (state == ShortControllStateLoading) {
        coverImageView.hidden = NO;
        [loadingIndicator startAnimating];
        indictorImage.hidden = YES;
        coverMask.hidden = YES;
        [self bringSubviewToFront:self];
    } else if (state == ShortControllStatePlaying) {
        coverImageView.hidden = YES;
        [loadingIndicator stopAnimating];
        indictorImage.hidden = YES;
        coverMask.hidden = YES;
        [self bringSubviewToFront:self];
    }  else if (state == ShortControllStatePaused) {
        coverImageView.hidden = YES;
        [loadingIndicator stopAnimating];
        indictorImage.hidden = NO;
        coverMask.hidden = NO;
        [self.superview bringSubviewToFront:self];
    }
}
-(void)tapAction:(UIButton *)sender
{
    if (self.playOrPauseBlock) {
        self.playOrPauseBlock();
    }

}

@end
