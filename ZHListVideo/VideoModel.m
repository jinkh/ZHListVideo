//
//  VideoModel.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "VideoModel.h"


@implementation VideoModel

+(VideoModel *)initWithDictionary:(NSDictionary *)dic
{
    VideoModel *model = [[VideoModel alloc] init];
    model.title = [dic objectForKey:@"title"];
    model.videUrl = [dic objectForKey:@"videoUrl"];
    model.picUrl = [dic objectForKey:@"picUrl"];
    model.picWidth = [dic objectForKey:@"picWidth"];
    model.picHeight = [dic objectForKey:@"picHeight"];
    model.picFixHeight = [[UIScreen mainScreen] bounds].size.width/[model.picWidth integerValue]*[model.picHeight integerValue];
    model.picFixWidth = [[UIScreen mainScreen] bounds].size.width;
    
    return model;
}


@end
