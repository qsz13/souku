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
@property (nonatomic,strong) UIButton *notificationButton;
@property (nonatomic) BOOL notificationIsOn;
@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
        self.settingItems = @[@"离线地图",@"停车位刷新间隔",@"通知栏消息",@"反馈",@"关于"];
        self.settingOfflineViewController = [[SettingOfflineViewController alloc] init];
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
    [cell.textLabel setTextColor:[UIColor colorWithRed:0.0f green:138.0f/255.0f blue:1.0f alpha:1.0]];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    if([cell.textLabel.text  isEqual: @"通知栏消息"])
    {
        self.notificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.notificationButton.frame = CGRectMake(cell.contentView.bounds.size.width - 70 - 5.0f,
                                     (cell.contentView.bounds.size.height +128 ) / 2.0f,60,48);

        [self.notificationButton setImage:[UIImage imageNamed:@"switchIconOn"] forState:UIControlStateNormal];
        [self.view addSubview:self.notificationButton];
        [self.notificationButton addTarget:self action:@selector(notificationSwitch) forControlEvents:UIControlEventTouchDragInside];
        
        
        
    }

    return cell;
}

- (void)notificationSwitch
{
    if(self.notificationIsOn)
    {
        self.notificationIsOn = NO;
        [self.notificationButton setImage:[UIImage imageNamed:@"switchIconOff"] forState:UIControlStateNormal];
    }
    else
    {
        self.notificationIsOn = YES;
        [self.notificationButton setImage:[UIImage imageNamed:@"switchIconOn"] forState:UIControlStateNormal];
    }
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

}



@end
