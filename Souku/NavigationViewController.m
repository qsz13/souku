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
@property (nonatomic) CLLocationCoordinate2D currentCoordinate;
@property (strong, nonatomic) MAUserLocation *currentLocation;
@property (strong,nonatomic) NSMutableArray *annotations;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UIView *buttomBar;
@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UILabel *estimatedTimeLabel;
@property (nonatomic, strong) UIAlertView *exitAlertView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

CGRect screenRect;
CGFloat screenWidth;
CGFloat screenHeight;

@implementation NavigationViewController


@synthesize route;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.search = [[AMapSearchAPI alloc] initWithSearchKey: (NSString *)APIKey Delegate:self];
        screenRect = [[UIScreen mainScreen] bounds];
        screenWidth = screenRect.size.width;
        screenHeight = screenRect.size.height;
        self.exitAlertView = [[UIAlertView alloc] initWithTitle:@"确定退出导航？" message:@"" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initMap];
    [self initNavigationPoint];
    [self initTopBar];
    [self initButtomBar];
    [self initHUD];

    self.title = @"导航";
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

- (void)initTopBar
{
    self.topBar = [[UIView alloc]init];
    [self.topBar setFrame:CGRectMake(0, -1, screenWidth, screenHeight/10)];
    
    UIImageView *background = [[UIImageView alloc]init];
    background.image = [UIImage imageNamed:@"navigationTopBackground"];
    [background setFrame:CGRectMake(0, 0, screenWidth , 20+screenHeight/12)];
    [self.topBar addSubview:background];
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    nameLabel.text = self.poi.name;
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setFrame:CGRectMake(screenWidth/3.5, 10, screenWidth-screenWidth/3.5, self.topBar.frame.size.height)];
    nameLabel.adjustsFontSizeToFitWidth = NO;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [nameLabel setFont:[UIFont boldSystemFontOfSize:20]];
    
    [self.topBar addSubview:nameLabel];
    
    [self.view addSubview:self.topBar];
}

- (void)initButtomBar
{
    self.buttomBar = [[UIView alloc]init];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        [self.buttomBar setFrame:CGRectMake(0,screenHeight*11/12, screenWidth, screenHeight/12)];

    }
    else
    {
        [self.buttomBar setFrame:CGRectMake(0,screenHeight*11/12-20, screenWidth, screenHeight/12)];

    }
    
    
    
    UIImageView *background = [[UIImageView alloc]init];
    background.image = [UIImage imageNamed:@"navigationButtomBackground"];
    [background setFrame:CGRectMake(0, 0, screenWidth , screenHeight/12)];
    [self.buttomBar addSubview:background];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exitButton setImage:[UIImage imageNamed:@"navigationExit"] forState:UIControlStateNormal];
    [exitButton setImage:[UIImage imageNamed:@"navigationExit"] forState:UIControlStateHighlighted];
    [exitButton setFrame:CGRectMake(screenWidth/20, self.buttomBar.frame.size.height/3, self.buttomBar.frame.size.height/3, self.buttomBar.frame.size.height/3)];
    [exitButton addTarget:self action:@selector(exitButtonTouched) forControlEvents:UIControlEventTouchDown];
    [self.buttomBar addSubview:exitButton];
    
    self.distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/4, self.buttomBar.frame.size.height/3, 120, self.buttomBar.frame.size.height/3)];
    self.distanceLabel.text = @"计算中";
    [self.buttomBar addSubview:self.distanceLabel];

    self.estimatedTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/5+130, self.buttomBar.frame.size.height/3, 150, self.buttomBar.frame.size.height/3)];
    self.estimatedTimeLabel.text = @"计算中";
    [self.buttomBar addSubview:self.estimatedTimeLabel];

    
    [self.view addSubview:self.buttomBar];
}

- (void)exitButtonTouched
{
    
    [self.exitAlertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [self.exitAlertView cancelButtonIndex])
    {
        
    }
    else
    {
        [self returnAction];
    }
}

-(void)initNavigationPoint
{
    self.currentLocation = [[MapView sharedManager] getCurrentLocation];
    NSLog(@"%@",self.currentLocation);
    self.startCoordinate        = self.currentLocation.coordinate;
    self.destinationCoordinate  = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
    
    
    [self addDefaultAnnotations];
    [self searchNaviDrive];
}

- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request
                      response:(AMapNavigationSearchResponse *)response
{
    [self.hud hide:YES];
    

    if (response.route == nil)
    {
        return;
    }
    
    self.route = response.route;
    AMapPath *path = self.route.paths[0];
    self.distanceLabel.text = [NSString stringWithFormat:@"%d米",path.distance];
    self.estimatedTimeLabel.text = [NSString stringWithFormat:@"%d 分钟",path.duration/60];
    [self.distanceLabel setBackgroundColor:[UIColor clearColor]];
    [self.estimatedTimeLabel setBackgroundColor:[UIColor clearColor]];
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
    [self addDefaultAnnotations];
    [self performSelectorOnMainThread:@selector(presentCurrentCourse) withObject:nil waitUntilDone:YES];

}



-(void)initMap
{
    self.mapView = [[MapView sharedManager] getMap];
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    
    [self.view addSubview:self.mapView];
}

-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
//    NSLog(@"userlocation :%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
//    NSLog(@"currentlocation :%f,%f",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
    if(userLocation.coordinate.longitude != self.currentCoordinate.longitude || userLocation.coordinate.latitude != self.currentCoordinate.latitude)
    {
        self.currentCoordinate = userLocation.coordinate;
        self.startCoordinate = userLocation.coordinate;
        [self searchNaviDrive];
    }
    
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
    if(self.route.paths.count>0)
    {
        polylines = [CommonUtility polylinesForPath:self.route.paths[0]];

    }

    [self.mapView addOverlays:polylines];
    
    /* 缩放地图使其适应polylines的展示. */
    self.mapView.visibleMapRect = [CommonUtility mapRectForOverlays:polylines];
}





- (void)addDefaultAnnotations
{
//    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
//    startAnnotation.coordinate = self.startCoordinate;
//    startAnnotation.title      = (NSString*)NavigationViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
//    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinationCoordinate;
    destinationAnnotation.title      = (NSString*)NavigationViewControllerDestinationTitle;
    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
    
    //[self.mapView addAnnotation:startAnnotation];
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
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];


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




@end
