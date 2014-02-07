//
//  LocationDetailViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/3/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LocationDetailViewController

@synthesize poi = _poi;
@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitle];
    [self initContent];
    [self initButton];

}

- (void)initTitle
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor  = [UIColor clearColor];
    titleLabel.text             = @"详细信息";
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

-(void)viewDidLayoutSubviews
{
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.text = self.poi.address;
    [self.addressLabel sizeToFit];
}

-(void)initContent
{
    self.poiNameLabel.text = self.poi.name;
    self.poiNameLabel.font = [UIFont systemFontOfSize:18];
    [self.poiNameLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize s = [self.poiNameLabel.text sizeWithFont:[UIFont systemFontOfSize:20]
                  constrainedToSize:CGSizeMake(self.view.bounds.size.width - 40,     CGFLOAT_MAX)  // - 40 For cell padding
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.poiNameLabel setFrame:CGRectMake(50, 50, s.width, s.height)];
    

    
    NSArray *phoneArray = [self.poi.tel componentsSeparatedByString:@";"];
    
    self.phoneNumber.text = self.poi.tel;
    for(NSString *p in phoneArray)
    {
        // TO BE DONE
    }
    
}


-(void)initButton
{
    [self.navigationButton addTarget:self action:@selector(pushToNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.favouriteButton addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];

}


-(void)pushToNavigation
{
    NavigationViewController *navigationViewController = [[NavigationViewController alloc] init];
    navigationViewController.poi = self.poi;
    navigationViewController.currentLocation = self.currentLocation;
    [[self navigationController] pushViewController:navigationViewController animated:YES];
}

-(void)favourite
{
    LocationDataController *locationDataController = [[LocationDataController alloc]init];
    [locationDataController initializeDefaultDataList];
    [locationDataController addPOI:self.poi];
}



@end
