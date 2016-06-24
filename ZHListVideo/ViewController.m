//
//  ViewController.m
//  ZHListVideo
//
//  Created by Zinkham on 16/3/23.
//  Copyright © 2016年 Zinkham. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "VideoModel.h"
#import "TestAutoPauseController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *myTableView;
    
    NSMutableArray *data;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [myTableView setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    [self.view addSubview:myTableView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"jump" style:UIBarButtonItemStylePlain target:self action:@selector(jumpAction:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)jumpAction:(id)sender
{
    TestAutoPauseController *test = [[TestAutoPauseController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ViewController"];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ViewController"];
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
