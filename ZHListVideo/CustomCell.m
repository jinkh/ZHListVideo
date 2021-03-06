//
//  CustomCell.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell()
{
    UILabel *titleLabel;
    ZHShortPlayerView *videoView;
}
@end

@implementation CustomCell

-(void)dealloc
{
    NSLog(@"release class:%@",NSStringFromClass([self class]));
    // 重要, 必须对videoView进行destory，否则内存无法释放
    [videoView destroy];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        videoView = [[ZHShortPlayerView alloc] initWithFrame:CGRectZero withIdentifier:reuseIdentifier];
        [self addSubview:videoView];
        
        titleLabel = [[UILabel alloc] init];
        [self addSubview:titleLabel];
        
    }
    return self;
}

-(void)fillData:(VideoModel *)data
{
    
    titleLabel.frame = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width-20, 0);
    titleLabel.text = data.title;
    titleLabel.hidden = YES;
    
    videoView.frame = CGRectMake(0, 10, data.picFixWidth, data.picFixHeight);
    [videoView setVideoUrl:data.videUrl coverUrl:data.picUrl];
}

+(CGFloat)heightForCellWithData:(VideoModel *)data
{
    return 10+0+data.picFixHeight;
}

@end
