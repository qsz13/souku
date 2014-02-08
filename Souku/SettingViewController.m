//
//  SettingViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingOfflineViewController.h"

@interface SettingViewController ()

@property (nonatomic,strong) SettingOfflineViewController *settingOfflineViewController;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        //self.tabBarItem.image = [UIImage imageNamed:@"settingItem"];
        self.settingItems = @[@"离线地图",@"停车位刷新间隔",@"通知栏消息",@"反馈",@"关于"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.settingTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.settingTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.settingTableView setScrollEnabled:NO];
    
    self.settingTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.settingTableView.delegate = self;
    self.settingTableView.dataSource = self;
    [self.settingTableView reloadData];
    
    self.view = self.settingTableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.settingItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.settingItems objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    switch(indexPath.row)
    {
        case 0:
            self.settingOfflineViewController = [[SettingOfflineViewController alloc] init];
            self.settingOfflineViewController.hidesBottomBarWhenPushed = YES;

            [[self navigationController] pushViewController:self.settingOfflineViewController animated:YES];
            break;
    }
    
//    AroundMapViewController *aroundMapViewController = [[AroundMapViewController alloc] init];
//    aroundMapViewController.searchKey = [self.aroundItem objectAtIndex:indexPath.row];
//    aroundMapViewController.hidesBottomBarWhenPushed = YES;
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
//    [[self navigationController] pushViewController:aroundMapViewController animated:YES];
}



@end
