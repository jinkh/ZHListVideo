//
//  CustomCell.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "CustomCell.h"
#import "ZHShortPlayerView.h"

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
    
    titleLabel.frame = CGRectMake(10, 10, [[UIScreen mainScreen] bounds].size.width-20, 30);
    titleLabel.text = data.title;
    
    videoView.frame = CGRectMake(0, 40, data.picFixWidth, data.picFixHeight);
    [videoView setVideoUrl:data.videUrl coverUrl:data.picUrl];
}

+(CGFloat)heightForCellWithData:(VideoModel *)data
{
    return 10+30+data.picFixHeight;
}

@end
