//
//  AroundMapViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/2/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MapView.h"
@interface SearchResultViewController ()

@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) UITableView *resultTableView;
@property (strong, nonatomic) NSMutableArray *poiAnnotations;
@property (strong, nonatomic) MAPinAnnotationView *poiAnnotationView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) UIBarButtonItem *mapButton;
@property (strong, nonatomic) UIBarButtonItem *tableButton;
@property (strong, nonatomic) LocationDetailViewController *locationDetailViewController;


@end

@implementation SearchResultViewController


@synthesize poiAnnotations;
@synthesize poiAnnotationView;

BOOL hasGotPOI;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey: (NSString *)APIKey Delegate:self];
        hasGotPOI = NO;
        self.currentLocation = [[MapView sharedManager]getCurrentLocation];
        self.poiArray = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initBaseNavigationBar];
    [self initHUD];
    [self initTableView];

    self.search.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initMapView];
    if(poiAnnotations == nil || self.poiArray == nil)
    {
        [self searchPoiByCenterCoordinate];

    }
    else
    {
        [self addAnnotationsReloadData];
    }
    
    
    if((![self.view.subviews containsObject:self.resultTableView])&&
       (![self.view.subviews containsObject:self.mapView]))
    {
        [self.view addSubview:self.mapView];
    }
    
    
}

- (void)initHUD
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = YES;
    self.hud.delegate = self;
    [self.navigationController.view addSubview:self.hud];
    UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [self.hud addGestureRecognizer:HUDSingleTap];
}

- (void)singleTap:(UITapGestureRecognizer*)sender
{
    [self.hud hide:YES];
}



-(void)initMapView
{
    self.mapView = [[MapView sharedManager] getMap];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;

}

-(void)initTableView
{
    self.resultTableView = [[UITableView alloc] init];
    self.resultTableView.frame = self.view.bounds;
    self.resultTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.resultTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;

    
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self.hud hide:YES];

}


- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        LocationDetailViewController *detail = [[LocationDetailViewController alloc] init];
        detail.poi = poiAnnotation.poi;
        //detail.currentLocation = self.currentLocation.location;
        [self clearMapView];
        /* 进入POI详情页面. */
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
   
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
            
            poiAnnotationView.canShowCallout = YES;
            
            poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}



- (void)initBaseNavigationBar
{
    if(self.tableButton == nil)
    {
        self.tableButton = [[UIBarButtonItem alloc] initWithTitle:@"table"
                                                    style:UIBarButtonItemStyleBordered
                                                    target:self
                                                    action:@selector(table)];
    }
    
    self.navigationItem.rightBarButtonItem = self.tableButton;
}


-(void)table
{
    if(self.resultTableView == nil)
    {
        [self initTableView];
    }
    if([self.view.subviews containsObject:self.mapView])
    {
        [self.mapView removeFromSuperview];
    }
    
    [self.view addSubview: self.resultTableView];
    //NSLog(@"%@",self.resultTableView);
    [self.resultTableView reloadData];

    
    if(self.mapButton == nil)
    {
        self.mapButton = [[UIBarButtonItem alloc] initWithTitle:@"map"
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(map)];

    }
    
    self.navigationItem.rightBarButtonItem = self.mapButton;
    
}

-(void)map
{
    if(self.mapView == nil)
    {
        [self initMapView];
    }
    if([self.view.subviews containsObject:self.resultTableView])
    {
        [self.resultTableView  removeFromSuperview];
    }
    
    
    [self.view addSubview: self.mapView];
    
    if(self.tableButton == nil)
    {
        self.tableButton = [[UIBarButtonItem alloc] initWithTitle:@"table"
                                                            style:UIBarButtonItemStyleBordered
                                                           target:self
                                                           action:@selector(table)];
    }
    self.navigationItem.rightBarButtonItem = self.tableButton;
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"resultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    AMapPOI *poi = [self.poiArray objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}



- (void)searchPoiByCenterCoordinate
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    //request.location            = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    request.location            = [AMapGeoPoint locationWithLatitude:23.134993 longitude:113.312591];
    request.keywords            = self.searchKey;
    /* 按照距离排序. */
    request.sortrule            = 1;
    request.requireExtension    = YES;
    
    /* 添加搜索结果过滤 */
    AMapPlaceSearchFilter *filter = [[AMapPlaceSearchFilter alloc] init];
    //filter.costFilter = @[@"100", @"200"];
    filter.requireFilter = AMapRequireGroupbuy;
    request.searchFilter = filter;
    
    [self.search AMapPlaceSearch:request];
}



- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    
//    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
//    for (AMapPOI *p in response.pois) {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//    }
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"Place: %@", result);
    
    
    
    hasGotPOI = YES;
    
    if (response.pois.count == 0)
    {
        hasGotPOI = NO;
        return;
    }
    
    poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *poi, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:poi]];
        [self.poiArray addObject:poi];
    }];
    [self addAnnotationsReloadData];
    

}


-(void)addAnnotationsReloadData
{
    [self.mapView addAnnotations:poiAnnotations];
    
    if (poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [poiAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
    }
    [self.resultTableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    self.locationDetailViewController = [[LocationDetailViewController alloc] init];
    //self.locationDetailViewController.currentLocation = self.currentLocation.location;
    self.locationDetailViewController.poi = [self.poiArray objectAtIndex:indexPath.row];
    self.locationDetailViewController.hidesBottomBarWhenPushed = YES;
    [self clearMapView];
    [[self navigationController] pushViewController:self.locationDetailViewController animated:YES];
    
}


-(void) showAnnotations
{

    [self.mapView addAnnotations:poiAnnotations];
    if (poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [poiAnnotations[0] coordinate];
    }
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
    }

}


-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    NSLog(@"qsz:get location failed");
    [self.hud hide:YES];

}



- (void)returnAction
{
    [self clearMapView];
    
    [self clearSearch];
    
    
    self.searchKey = nil;
   // self.currentLocation = nil;
    self.poiArray = nil;
    self.resultTableView = nil;
    

    self.poiAnnotations = nil;
    self.poiAnnotationView = nil;
    self.hud = nil;
    self.mapButton = nil;
    self.tableButton = nil;
    self.locationDetailViewController = nil;
    
}


- (void)clearMapView
{
    //self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = [MapView sharedManager];
    
    

}

- (void)clearSearch
{
    self.search.delegate = nil;
    self.search = nil;
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self returnAction];
    }
    [super viewWillDisappear:animated];
}

@end
