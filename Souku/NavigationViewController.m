//
//  NavigationViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/4/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "NavigationViewController.h"
#import "MapView.h"


const NSString *NavigationViewControllerStartTitle       = @"起点";
const NSString *NavigationViewControllerDestinationTitle = @"终点";

@interface NavigationViewController ()


@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic) CLLocationCoordinate2D startCoordinate;
@property (nonatomic) CLLocationCoordinate2D destinationCoordinate;
@property (strong,nonatomic) NSMutableArray *annotations;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation NavigationViewController


@synthesize route;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey: (NSString *)APIKey Delegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMap];
    [self initNavigationPoint];
    self.title = @"导航";
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

-(void)initNavigationPoint
{
    
    MAUserLocation *currentLocation = [[MapView sharedManager] getCurrentLocation];
    NSLog(@"%@",currentLocation);
    self.startCoordinate        = currentLocation.coordinate;
    self.destinationCoordinate  = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
    
    
    [self addDefaultAnnotations];
    [self searchNaviDrive];
}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
     NSLog(@"search done");
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self performSelectorOnMainThread:@selector(presentCurrentCourse) withObject:nil waitUntilDone:YES];

}



-(void)initMap
{
    self.mapView = [[MapView sharedManager] getMap];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}





- (void)searchNaviDrive
{

    AMapNavigationSearchRequest *navi = [[AMapNavigationSearchRequest alloc] init];
    navi.searchType       = AMapSearchType_NaviDrive;
    navi.requireExtension = YES;
    
    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude
                                           longitude:self.startCoordinate.longitude];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:self.destinationCoordinate.latitude
                                                longitude:self.destinationCoordinate.longitude];

    [self.search AMapNavigationSearch:navi];
   

}



- (void)presentCurrentCourse
{
    NSArray *polylines = nil;
    
    polylines = [CommonUtility polylinesForPath:self.route.paths[0]];

    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}





- (void)addDefaultAnnotations
{
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title      = (NSString*)NavigationViewControllerStartTitle;
    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)NavigationViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];

}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
            
            poiAnnotationView.canShowCallout = YES;
        }

        /* 起点. */
        if ([[annotation title] isEqualToString:(NSString*)NavigationViewControllerStartTitle])
        {

            poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];
        }
        /* 终点. */
        else if([[annotation title] isEqualToString:(NSString*)NavigationViewControllerDestinationTitle])
        {
            poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];
        }
        
        return poiAnnotationView;
    }
    return nil;
}


- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
 
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth   = 4;
        overlayView.strokeColor = [UIColor magentaColor];
        overlayView.lineDashPattern = @[@5, @10];
        
        return overlayView;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth   = 8;
        overlayView.strokeColor = [UIColor magentaColor];
        
        return overlayView;
    }
    
    return nil;
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

    
    self.poi = nil;
}

- (void)clearSearch
{
    self.search.delegate = nil;
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self returnAction];
    }
    [super viewWillDisappear:animated];
}



@end
