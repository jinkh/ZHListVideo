//
//  TestAutoPauseController.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "VideoModel.h"
#import "TestAutoPauseController.h"

@interface TestAutoPauseController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    
    NSMutableArray *data;
}

@end

@implementation TestAutoPauseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    data = [[NSMutableArray alloc] init];
    NSBundle *bundle=[NSBundle mainBundle];
    NSString *path=[bundle pathForResource:@"data" ofType:@"plist"];
    NSArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        VideoModel *model = [VideoModel initWithDictionary:dic];
        [data addObject:model];
    }
    
    myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.scrollsToTop = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestAutoPauseController"];
    if (cell == nil) {
        //重要不同的tableView, identifier必须不同, 否则会混乱
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestAutoPauseController"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VideoModel *model = [data objectAtIndex:indexPath.row];
    [cell fillData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model = [data objectAtIndex:indexPath.row];
    return [CustomCell heightForCellWithData:model];
}


@end

