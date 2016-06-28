//
//  CustomCell.h
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "ZHShortPlayerView.h"

@interface CustomCell : UITableViewCell

-(void)fillData:(VideoModel *)data;

+(CGFloat)heightForCellWithData:(VideoModel *)data;

@end
