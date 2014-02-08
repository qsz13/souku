//
//  SettingOfflineViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/8/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SettingOfflineViewController.h"
#import <AMapSearchKit/MA>

@interface SettingOfflineViewController ()

@property(nonatomic,strong) UITableView *citysSelectTable;
@property(nonatomic,strong) UILabel *tableTitle;

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
    self.navigationController.title = @"离线地图";
    [self initTableView];

}

- (void)getCities
{
    NSArray*cities = [MAOfflineMap sharedOfflineMap].offlineCities;
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
    //    NSLog(@"%f",screenWidth);
    //    NSLog(@"x:%f,y:%f,width:%f,height:%f",2*w,h,screenWidth-2*w,screenHeight-2*h);
    //    NSLog(@"%f,%f",w,h);
    self.citysSelectTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    
    self.citysSelectTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.citysSelectTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.citysSelectTable.delegate = self;
    self.citysSelectTable.dataSource = self;
    [self.citysSelectTable reloadData];

    
    [self.view addSubview:self.citysSelectTable];
    
    
    CGRect textFrame = CGRectMake(x,y+viewHeight,viewWidth,40);
    UILabel *tableTitleLabel = [[UILabel alloc] initWithFrame:textFrame];
    tableTitleLabel.text = @"全部";
    tableTitleLabel.textAlignment = NSTextAlignmentCenter;
    [tableTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.view addSubview:tableTitleLabel];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;




@end
