//
//  HomeViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "HomeViewController.h"
#import "APIKey.h"
#import "MapView.h"
#import "CommonUtility.h"
#import "POIAnnotation.h"
#import "POIAnnotationView.h"
#import "SearchResultViewController.h"


@interface HomeViewController ()

@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIBarButtonItem *searchButton;
@property (strong, nonatomic) UIBarButtonItem *listButton;
@property (strong, nonatomic) UIBarButtonItem *appLogo;
@property (strong, nonatomic) UIBarButtonItem *appName;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *parkingLotTableView;
@property (strong, nonatomic) UITableView *searchResultTable;
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) AMapSearchAPI *searchAPI;
@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (strong, nonatomic) UITapGestureRecognizer *cancelSearchTap;
@property (strong, nonatomic) MAUserLocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *parkArray;
@property (strong, nonatomic) NSMutableArray *parkAnnotations;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) LocationDetailViewController *locationDetailViewController;
@property (strong, nonatomic) NSString *searchKey;
@property (strong, nonatomic) POIAnnotationView *poiAnnotationView;
@property (strong, nonatomic) UIButton *parkSwitchButton;
@property (nonatomic) ParkingMapState parkingMapState;

@end

CGRect screenRect;
CGFloat screenWidth;
CGFloat screenHeight;
   

@implementation HomeViewController

BOOL gotParkingInfo;
BOOL loadParkingInfo;

@synthesize poiAnnotationView;

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"主页";
        self.navigationItem.titleView = [[UILabel alloc] init];
        self.searchAPI = [[AMapSearchAPI alloc] initWithSearchKey: (NSString *)APIKey Delegate:self];
        self.searchResultArray = [[NSMutableArray alloc]init];
        self.parkArray = [[NSMutableArray alloc]init];
        gotParkingInfo = NO;
        screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        self.parkingMapState = ParkShowed;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    [self initTableView];
    [self initMapView];
    [self.view addSubview: self.parkingLotTableView];
    [self.parkingLotTableView reloadData];
    [self initHUD];
}



- (void)initHUD
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = NO;
    self.hud.delegate = self;
    [self.navigationController.view addSubview:self.hud];
   // UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
   // [self.hud addGestureRecognizer:HUDSingleTap];
}


- (void)initNavigationBar
{
    UIImage *logo =[UIImage imageNamed:@"logo"];
    UIImageView *logoView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    logoView.image = logo;
    self.appLogo = [[UIBarButtonItem alloc] initWithCustomView:logoView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    nameLabel.text = @"搜 库";
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    nameLabel.textColor = [UIColor whiteColor];
    [nameLabel sizeToFit];
    self.appName = [[UIBarButtonItem alloc] initWithCustomView:nameLabel];
    
    
    CGFloat squareSize = self.navigationController.navigationBar.frame.size.height*2/3;
    
    UIButton *mapButtonTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapButtonTemp setImage:[UIImage imageNamed:@"mapButton"] forState:UIControlStateNormal];
    [mapButtonTemp addTarget:self action:@selector(map) forControlEvents:UIControlEventTouchUpInside];
    [mapButtonTemp setFrame:CGRectMake(0, 0, squareSize, squareSize)];
    
    UIButton *refreshButtonTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButtonTemp setImage:[UIImage imageNamed:@"refreshButton"] forState:UIControlStateNormal];
    [refreshButtonTemp addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    [refreshButtonTemp setFrame:CGRectMake(0, 0, squareSize, squareSize)];
    
    UIButton *searchButtonTemp = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButtonTemp setImage:[UIImage imageNamed:@"searchButton"] forState:UIControlStateNormal];
    [searchButtonTemp addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchButtonTemp setFrame:CGRectMake(0, 0, squareSize, squareSize)];
    
    self.mapButton = [[UIBarButtonItem alloc] initWithCustomView:mapButtonTemp];
    self.refreshButton = [[UIBarButtonItem alloc] initWithCustomView:refreshButtonTemp];
    self.searchButton = [[UIBarButtonItem alloc] initWithCustomView:searchButtonTemp];
    
}


- (void)searchParkingLot
{
    
    

    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    request.searchType          = AMapSearchType_PlaceKeyword;
    request.keywords            = @"停车场";
    request.city = @[@"020"];
    //request.location            = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    request.requireExtension    = YES;
    [self.searchAPI AMapPlaceSearch:request];

}


- (void)searchPoiByKeyWord:(NSString *)keyWord
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    
    self.currentLocation = [[MapView sharedManager]getCurrentLocation];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.currentLocation.coordinate.latitude longitude:self.currentLocation.coordinate.longitude];
    //request.location            = [AMapGeoPoint locationWithLatitude:23.134993 longitude:113.312591];
    request.keywords            = keyWord;
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    
    /* 添加搜索结果过滤 */
    AMapPlaceSearchFilter *filter = [[AMapPlaceSearchFilter alloc] init];
    //filter.costFilter = @[@"100", @"200"];
    filter.requireFilter = AMapRequireGroupbuy;
    request.searchFilter = filter;
    //NSLog(@"%@",keyWord);
    [self.searchAPI AMapPlaceSearch:request];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText  isEqual: @""])
    {
        [self.searchResultTable removeFromSuperview];
        
        [self addGesture];
       

    }
    else
    {
        [self.view addSubview:self.searchResultTable];
        [self removeGesture];

    }

    [self searchPoiByKeyWord:searchText];
    

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchKey = searchBar.text;
}


- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
        NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
        NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
        NSString *strPoi = @"";
        for (AMapPOI *p in response.pois) {
            strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        }
        NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
        NSLog(@"Place: %@", result);
    
    
    if(loadParkingInfo == NO)
    {
        loadParkingInfo = YES;
        self.parkAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
        
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *poi, NSUInteger idx, BOOL *stop) {
            
            [self.parkAnnotations addObject:[[POIAnnotation alloc] initWithPOI:poi]];
            [self.parkArray addObject:poi];
        }];
        NSLog(@"!!!!!");
        

    }
    else
    {
        [self.searchResultArray removeAllObjects];
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *poi, NSUInteger idx, BOOL *stop) {
            [self.searchResultArray addObject:poi];
        }];
        
    }
    [self addAnnotationsReloadData];
    [self.searchResultTable reloadData];
    [self.parkingLotTableView reloadData];
    

    
    
}

-(void)addAnnotationsReloadData
{
    [self.mapView addAnnotations:self.parkAnnotations];
    
    if (self.parkAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [self.parkAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:self.parkAnnotations animated:YES];
    }
    [self.parkingLotTableView reloadData];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        poiAnnotationView = (POIAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[POIAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            
            poiAnnotationView.canShowCallout = YES;
            poiAnnotationView.canShowButtomCallout = NO;
            //poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        }
        
        [poiAnnotationView setIconImage :[UIImage imageNamed:@"locationResultIcon"] ];
        int num = [self.parkAnnotations indexOfObject:annotation]+1;
        NSString *numString = [NSString stringWithFormat:@"%d",num];
        [poiAnnotationView setIDLabel:numString];
        return poiAnnotationView;
    }
    
    return nil;
}


- (void)addGesture
{
    if([self.view.subviews containsObject:self.parkingLotTableView])
    {
        [self.parkingLotTableView addGestureRecognizer:self.cancelSearchTap];
    }
    else if([self.view.subviews containsObject:self.mapView])
    {
        [self.mapView addGestureRecognizer:self.cancelSearchTap];
    }
}

- (void)removeGesture
{
    if([self.view.subviews containsObject:self.parkingLotTableView])
    {
        [self.parkingLotTableView removeGestureRecognizer:self.cancelSearchTap];
    }
    else if([self.view.subviews containsObject:self.mapView])
    {
        [self.mapView removeGestureRecognizer:self.cancelSearchTap];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [self initToggleButon];
    NSArray *topLeftButtons;
    if(self.navigationItem.titleView == self.searchBar)
    {
        topLeftButtons= @[self.appLogo];
    }
    else{
        topLeftButtons= @[self.appLogo,self.appName];
    }
    
    self.navigationItem.leftBarButtonItems = topLeftButtons;

}




#pragma mark - Init Views

-(void)initTableView
{
    self.parkingLotTableView = [[UITableView alloc] init];
    self.parkingLotTableView.frame = self.view.bounds;

    self.parkingLotTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.parkingLotTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.parkingLotTableView.delegate = self;
    self.parkingLotTableView.dataSource = self;
    [self.parkingLotTableView reloadData];
    

    
}

-(void)initMapView
{
    self.mapView = [[MapView sharedManager] getMap];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];

}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    [self.hud hide:YES];
    if ([[MapView sharedManager]getCurrentLocation]==nil)
    {
        [[MapView sharedManager]setCurrentLocation:userLocation];

    }
    self.currentLocation = [[MapView sharedManager]getCurrentLocation];
    //NSLog(@"%@",self.currentLocation.);
    if(!gotParkingInfo)
    {
        [self searchParkingLot];
        gotParkingInfo = YES;
    }
    
    
}


-(void)initToggleButon
{
    if(self.navigationItem.titleView == self.searchBar)
    {
        return;
    }
    else{
    
        if([self.view.subviews containsObject: self.parkingLotTableView])
        {
            NSArray *topRightButtons= @[self.mapButton,self.refreshButton,self.searchButton];
            self.navigationItem.rightBarButtonItems = topRightButtons;
        }
        else if([self.view.subviews containsObject: self.mapView])
        {
            NSArray *topRightButtons= @[self.listButton,self.refreshButton,self.searchButton];
            self.navigationItem.rightBarButtonItems = topRightButtons;
        }
    }
}

#pragma mark - Button Callback
-(void)map
{
    if([self.view.subviews containsObject:self.parkingLotTableView])
    {
        [self.parkingLotTableView removeFromSuperview];
    }
    
    [self.view addSubview: self.mapView];
    if(self.listButton ==nil){
        CGFloat squareSize = self.navigationController.navigationBar.frame.size.height*2/3;
        
        UIButton *listButtonTemp = [UIButton buttonWithType:UIButtonTypeCustom];
        [listButtonTemp setImage:[UIImage imageNamed:@"listButton"] forState:UIControlStateNormal];
        [listButtonTemp addTarget:self action:@selector(list) forControlEvents:UIControlEventTouchUpInside];
        [listButtonTemp setFrame:CGRectMake(0, 0, squareSize, squareSize)];
        
        self.listButton = [[UIBarButtonItem alloc] initWithCustomView:listButtonTemp];
    }
    
    [self initParkSwitchButton];
    NSArray *topRightButtons= @[self.listButton,self.refreshButton,self.searchButton];
    self.navigationItem.rightBarButtonItems = topRightButtons;
}

- (void) initParkSwitchButton
{
    self.parkSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.parkSwitchButton setBackgroundImage:[UIImage imageNamed:@"parkShowed"] forState:UIControlStateNormal];
    [self.parkSwitchButton addTarget:self action:@selector(parkButtonSwitch) forControlEvents:UIControlEventTouchUpInside];
    [self.parkSwitchButton setFrame:CGRectMake(screenWidth*0.8, screenHeight*0.1, 30, 30)];
    [self.view addSubview:self.parkSwitchButton];

}

- (void) parkButtonSwitch
{
    if(self.parkingMapState == ParkShowed)
    {
        self.parkingMapState = ParkDisabled;
        [self.parkSwitchButton setBackgroundImage:[UIImage imageNamed:@"ParkDisabled"] forState:UIControlStateNormal];
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    else if(self.parkingMapState == ParkDisabled)
    {
        self.parkingMapState = ParkLeft;
        [self.parkSwitchButton setBackgroundImage:[UIImage imageNamed:@"ParkLeft"] forState:UIControlStateNormal];
    }
    else if(self.parkingMapState == ParkLeft)
    {
        self.parkingMapState = ParkShowed;
        [self.parkSwitchButton setBackgroundImage:[UIImage imageNamed:@"parkShowed"] forState:UIControlStateNormal];
        [self addAnnotationsReloadData];
    }


}

-(void)list
{
    
    if([self.view.subviews containsObject:self.mapView])
    {
        [self.mapView removeFromSuperview];
    }
    
    NSArray *topRightButtons= @[self.mapButton,self.refreshButton,self.searchButton];
    self.navigationItem.rightBarButtonItems = topRightButtons;
    [self.view addSubview: self.parkingLotTableView];
}

-(void)refresh
{
    NSLog(@"refresh");
}

-(void)search
{
    NSLog(@"search");
    NSArray *topLeftButtons= @[self.appLogo];
    self.navigationItem.leftBarButtonItems = topLeftButtons;
    self.navigationItem.rightBarButtonItems = nil;
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 255.0f,44.0f)];
    self.searchBar.delegate = self;
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [self.searchBar setSearchFieldBackgroundImage:[CommonUtility imageWithImage:[UIImage imageNamed:@"searchBar"] scaledToSize:self.searchBar.frame.size] forState:UIControlStateNormal];
    
    
    
    self.navigationItem.titleView = self.searchBar;

    self.cancelSearchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self addGesture];
    [self.searchBar becomeFirstResponder];
    
    [self initSearchResultTableView];

    
    
}

- (void)dismissKeyboard
{
    [self removeGesture];
    [self.searchBar resignFirstResponder];
    self.navigationItem.titleView = [[UILabel alloc]init];
    NSArray *topLeftButtons= @[self.appLogo,self.appName];
    self.navigationItem.leftBarButtonItems = topLeftButtons;
    
    [self initToggleButon];
}

-(void)initSearchResultTableView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat x = 10;
    CGFloat y = 10;
    CGFloat viewWidth = screenWidth - 2*x;
    CGFloat viewHeight = screenHeight - 2*y;
    
    CGRect tableFrame = CGRectMake(x, y, viewWidth, viewHeight);
    
    
    self.searchResultTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    
    self.searchResultTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.searchResultTable setBackgroundView:[[UIView alloc]init]];
    
    self.searchResultTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.searchResultTable.delegate = self;
    self.searchResultTable.dataSource = self;
    self.searchResultTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchResultTable.contentInset = UIEdgeInsetsZero;
    [self.searchResultTable reloadData];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.parkingLotTableView)
    {
        return self.parkArray.count;
    }
    else if(tableView == self.searchResultTable)
    {
        return self.searchResultArray.count;
    }
    NSLog(@"table unknow");
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    
    if(tableView == self.parkingLotTableView)
    {
        static NSString *cellIdentifier = @"parkCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        //cell.textLabel.text = [self.parkArray objectAtIndex:indexPath.row];
        AMapPOI *poi = [self.parkArray objectAtIndex:indexPath.row];
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;

        return cell;
    }
    else if(tableView == self.searchResultTable)
    {
        static NSString *cellIdentifier = @"searchCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        
        AMapPOI *poi = [self.searchResultArray objectAtIndex:indexPath.row];
        cell.textLabel.text = poi.name;
        cell.detailTextLabel.text = poi.address;

        return cell;
    }
    NSLog(@"table unknow");

    return nil;
    
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if(tableView == self.searchResultTable)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        self.locationDetailViewController = [[LocationDetailViewController alloc] init];
        
        self.locationDetailViewController.poi = [self.searchResultArray objectAtIndex:indexPath.row];
        self.locationDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: self.locationDetailViewController animated:YES];
    }
    else if(tableView == self.parkingLotTableView)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        self.locationDetailViewController = [[LocationDetailViewController alloc] init];
        self.locationDetailViewController.poi = [self.parkArray objectAtIndex:indexPath.row];
        self.locationDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController: self.locationDetailViewController animated:YES];
    }
    

}

- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
}


- (void)clearMapView
{
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = [MapView sharedManager];
    
}

- (void)clearSearch
{
    self.searchAPI.delegate = nil;
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self returnAction];
    }
    [super viewWillDisappear:animated];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.mapView.delegate = [MapView sharedManager];
    
}

@end
