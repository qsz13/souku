//
//  AroundViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AroundViewController.h"


@interface AroundViewController ()

@property (strong, nonatomic) UITableView *aroundTableView;
@property (strong, nonatomic) AroundMapViewController *aroundMapViewController;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation AroundViewController

@synthesize aroundItem;
@synthesize HUD;

#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"周边";
        //self.tabBarItem.image = [UIImage imageNamed:@"aroundItem"];
        self.aroundItem = @[@"酒店住宿",@"餐饮服务",@"购物服务",@"生活服务",@"体育休闲",@"医疗保健",@"风景名胜"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
}

- (void)initTableView
{
    self.aroundTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.aroundTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.aroundTableView setScrollEnabled:NO];
    self.aroundTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    self.aroundTableView.delegate = self;
    self.aroundTableView.dataSource = self;
    [self.aroundTableView reloadData];
    self.view = self.aroundTableView;

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return aroundItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
    cell.textLabel.textColor = [UIColor colorWithRed:0.0f green:138.0f/255.0f blue:1.0f alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22.0];
    cell.textLabel.text = [self.aroundItem objectAtIndex:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator]; 
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    self.aroundMapViewController = [[AroundMapViewController alloc] init];
    NSString *searchKey = [self.aroundItem objectAtIndex:indexPath.row];
    self.aroundMapViewController.searchKey = searchKey;
    self.aroundMapViewController.hidesBottomBarWhenPushed = YES;
    [[self navigationController] pushViewController:self.aroundMapViewController animated:YES];

}


@end
