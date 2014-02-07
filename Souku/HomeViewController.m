//
//  HomeViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *appLogo;
@property (strong, nonatomic) UIBarButtonItem *appName;
@property (strong, nonatomic) UITableView *parkingLotTableView;
@property (strong, nonatomic) MAMapView *mapView;

@end

@implementation HomeViewController




#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"主页";
        //self.tabBarItem.image = [UIImage imageNamed:@"homeItem"];
        self.navigationItem.title = @"";
        self.mapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:(self) action:@selector(map)];
        self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:(self) action:@selector(refresh)];
        self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:(self) action:@selector(search)];
        
        self.appLogo = [[UIBarButtonItem alloc] init];
        [self.appLogo setTitle:@"logo"];
        self.appName = [[UIBarButtonItem alloc] init];
        [self.appName setTitle:@"搜库"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self initMapView];
    self.view = self.parkingLotTableView;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self initToggleButon];
    NSArray *topLeftButtons= @[self.appLogo,self.appName];
    self.navigationItem.leftBarButtonItems = topLeftButtons;

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsUserLocation = YES;    //YES turn on positioning, NO turn off positioning
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
}



#pragma mark - Init Views

-(void)initTableView
{
    self.parkingLotTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.parkingLotTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.parkingLotTableView.delegate = self;
    self.parkingLotTableView.dataSource = self;
    [self.parkingLotTableView reloadData];
}

-(void)initMapView
{
    self.mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
}

-(void)initToggleButon
{
    if(self.view == self.parkingLotTableView)
    {
        NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.mapButton,self.refreshButton,self.searchButton, nil];
        self.navigationItem.rightBarButtonItems = topRightButtons;
    }
    else if(self.view == self.mapView)
    {
        NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.listButton,self.refreshButton,self.searchButton, nil];
        self.navigationItem.rightBarButtonItems = topRightButtons;
    }
}

#pragma mark - Button Callback
-(void)map
{
    self.view = self.mapView;
    if(self.listButton ==nil){
        self.listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(list)];
    }
    NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.listButton,self.refreshButton,self.searchButton, nil];
    self.navigationItem.rightBarButtonItems = topRightButtons;
}

-(void)list
{
    
    NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.mapButton,self.refreshButton,self.searchButton, nil];
    self.navigationItem.rightBarButtonItems = topRightButtons;
    self.view = self.parkingLotTableView;
}

-(void)refresh
{
    NSLog(@"refresh");
}

-(void)search
{
    NSLog(@"search");
}


#pragma mark - Positioning Callback
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    self.currentLocation = userLocation.location;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parkArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"homeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.parkArray objectAtIndex:indexPath.row];
    return cell;
    
}

@end
