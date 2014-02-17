//
//  SettingOfflineViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/8/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SettingOfflineViewController.h"
#import <MAMapKit/MAOfflineMap.h>

@interface SettingOfflineViewController ()

@property(nonatomic,strong) UITableView *citysSelectTable;
@property(nonatomic,strong) UILabel *tableTitle;
@property(nonatomic,strong) NSArray *cityList;
@end

@implementation SettingOfflineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self getCities];
    [self initTableView];

}

- (void)getCities
{
     self.cityList = [MAOfflineMap sharedOfflineMap].offlineCities;
}

-(void)initTableView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat x =40;
    CGFloat y = 2*self.navigationController.navigationBar.frame.size.height;
    
    CGFloat viewWidth = screenWidth - 2*x;
    CGFloat viewHeight = screenHeight - 2*y;
    
    CGRect tableFrame = CGRectMake(x, y, viewWidth, viewHeight);
    self.citysSelectTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    
    self.citysSelectTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.citysSelectTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.citysSelectTable.delegate = self;
    self.citysSelectTable.dataSource = self;
    self.citysSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.citysSelectTable reloadData];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }    [self.view addSubview:self.citysSelectTable];
    
    
    CGRect textFrame = CGRectMake(x,y+viewHeight,viewWidth,40);
    UILabel *tableTitleLabel = [[UILabel alloc] initWithFrame:textFrame];
    tableTitleLabel.text = @"全部";
    tableTitleLabel.textAlignment = NSTextAlignmentCenter;
    [tableTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.view addSubview:tableTitleLabel];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    MAOfflineCity *selected = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.text = selected.cityName;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
