//
//  NavigationViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/4/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "NavigationViewController.h"

const NSString *NavigationViewControllerStartTitle       = @"起点";
const NSString *NavigationViewControllerDestinationTitle = @"终点";

@interface NavigationViewController ()

@property (nonatomic, strong) AMapRoute *route;
@property (nonatomic, strong) NSLock *lock;
@end

@implementation NavigationViewController

@synthesize bottomToolbar;
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
    
    [self initNavigationBar];
    [self initMap];
    [self initTitleBar];
    [self initToolBar];
 
    [NSThread detachNewThreadSelector:@selector(initNavigationPoint) toTarget:self withObject:nil];
    
    
}

-(void)initNavigationPoint
{
    if(self.currentLocation == nil)
    {
        while(self.currentLocation == nil)
        {
            sleep(1);
        }
    }

    self.startCoordinate        = self.currentLocation.coordinate;
    self.destinationCoordinate  = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
    
    
    [self addDefaultAnnotations];
    [self searchNaviDrive];
    [[NSRunLoop currentRunLoop] run];
}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    NSLog(@"kajsdhflkj");
    
    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    [self performSelectorOnMainThread:@selector(presentCurrentCourse) withObject:nil waitUntilDone:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.showsUserLocation = YES;    //YES turn on positioning, NO turn off positioning
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES];
}


-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"got it!");
    self.currentLocation = userLocation.location;

}


-(void)initMap
{
    self.mapView=[[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

-(void)initTitleBar
{
    UIToolbar *topToolbar = [[UIToolbar alloc] init];
    topToolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    [self.view addSubview:topToolbar];
}


-(void)initToolBar
{
    bottomToolbar = [[UIToolbar alloc] init];
    bottomToolbar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 60, [[UIScreen mainScreen] bounds].size.width, 60);
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(returnAction)];
    [items addObject:back];
    
    bottomToolbar.items = items;

    [self.view addSubview:bottomToolbar];

}



-(void)initNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
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
    
    NSLog(@"%@",polylines);
    
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
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    
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


@end
