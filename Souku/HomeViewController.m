//
//  HomeViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    if(self.view == self.parkingLotTableView)
    {
        NSLog(@"mapButton");
        NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.mapButton,self.refreshButton,self.searchButton, nil];
        self.navigationItem.rightBarButtonItems = topRightButtons;

    }
    else if(self.view == self.mapView)
    {
        NSLog(@"listButton");
        NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.listButton,self.refreshButton,self.searchButton, nil];
        self.navigationItem.rightBarButtonItems = topRightButtons;

    }
    NSArray *topLeftButtons= @[self.appLogo,self.appName];
    self.navigationItem.leftBarButtonItems = topLeftButtons;


}

-(void)map
{
    NSLog(@"change to map");
    if(self.mapView == nil){
        NSLog(@"mapview nil!!!!");
    }
    self.view = self.mapView;
    if(self.listButton ==nil){
        self.listButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(list)];
    }
    NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.listButton,self.refreshButton,self.searchButton, nil];
    self.navigationItem.rightBarButtonItems = topRightButtons;
}

-(void)list
{
    NSLog(@"list");
    if(self.mapButton == nil){
        NSLog(@"mapButton nil!!");
    }
    NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.mapButton,self.refreshButton,self.searchButton, nil];
    self.navigationItem.rightBarButtonItems = topRightButtons;
    if(self.parkingLotTableView == nil){
        NSLog(@"parkingLotTableView is nil");
    }
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self initMapView];
    self.view = self.parkingLotTableView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    self.currentLocation = userLocation.location;
}

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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
