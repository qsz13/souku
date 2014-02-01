//
//  AroundMapViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/2/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AroundMapViewController.h"

@interface AroundMapViewController ()

@end

@implementation AroundMapViewController

@synthesize currentLocation;
BOOL hasGotPOI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey: (NSString *)APIKey Delegate:self];
        hasGotPOI = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
}

- (void)searchPoiByCenterCoordinate
{
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.location            = [AMapGeoPoint locationWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
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

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!坐标会偏移

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation
updatingLocation:(BOOL)updatingLocation
{
    currentLocation = userLocation.location;
    if(!hasGotPOI)
    {
        [self searchPoiByCenterCoordinate];
    }
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
    
    
    hasGotPOI = YES;
    
    if (response.pois.count == 0)
    {
        hasGotPOI = NO;
        return;
    }
    
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
    /* 将结果以annotation的形式加载到地图上. */
    [self.mapView addAnnotations:poiAnnotations];
    
    /* 如果只有一个结果，设置其为中心点. */
    if (poiAnnotations.count == 1)
    {
        self.mapView.centerCoordinate = [poiAnnotations[0] coordinate];
    }
    /* 如果有多个结果, 设置地图使所有的annotation都可见. */
    else
    {
        [self.mapView showAnnotations:poiAnnotations animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)mapView:(MAMapView*)mapView didFailToLocateUserWithError:(NSError*)error
{
    NSLog(@"get location failed");
}

@end