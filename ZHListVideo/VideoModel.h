//
//  VideoModel.h
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *picUrl;
@property (assign, nonatomic) CGFloat picFixWidth;
@property (assign, nonatomic) CGFloat picFixHeight;

@property (strong, nonatomic) NSString * picWidth;
@property (strong, nonatomic) NSString * picHeight;
@property (strong, nonatomic) NSString *videUrl;

+(VideoModel *)initWithDictionary:(NSDictionary *)dic;

@end
