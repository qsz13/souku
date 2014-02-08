//
//  AroundMapViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/2/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "AroundMapViewController.h"

@interface AroundMapViewController ()

@property (strong, atomic) MAMapView *mapView;
@property (strong, nonatomic) NSMutableArray *poiAnnotations;
@property (strong, nonatomic) MAPinAnnotationView *poiAnnotationView;

@end

@implementation AroundMapViewController

@synthesize currentLocation;
@synthesize poiAnnotations;
@synthesize poiAnnotationView;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initBaseNavigationBar];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initMapView];

    self.mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [self.mapView setUserTrackingMode: MAUserTrackingModeNone animated:YES];
    
    
}

-(void)initMapView
{
   
    self.mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setCenterCoordinate:self.currentLocation.location.coordinate];
    self.mapView.delegate = self;
    self.view = self.mapView;


    
}

- (void)mapViewDidFinishLoadingMap:(MAMapView *)mapView dataSize:(NSInteger)dataSize
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    

    NSLog(@"mapViewDidFinishLoadingMap");

    
}



- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    id<MAAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[POIAnnotation class]])
    {
        POIAnnotation *poiAnnotation = (POIAnnotation*)annotation;
        
        LocationDetailViewController *detail = [[LocationDetailViewController alloc] initWithNibName:@"LocationDetail" bundle:nil];
        detail.poi = poiAnnotation.poi;
        detail.currentLocation = self.currentLocation.location;
        
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnAction)];
}

- (void)returnAction
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self clearMapView];
    
    [self clearSearch];
}
- (void)clearMapView
{
    self.mapView.showsUserLocation = NO;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [self.mapView removeOverlays:self.mapView.overlays];
    
    self.mapView.delegate = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}
- (void)searchPoiByCenterCoordinate
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSLog(@"search!!!!!!!!\n\n");
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
        currentLocation = userLocation;
    if(!hasGotPOI)
    {
        [self searchPoiByCenterCoordinate];
    }
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
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
        
    }];
    
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
}

@end
