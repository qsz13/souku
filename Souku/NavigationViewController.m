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

@end

@implementation NavigationViewController

@synthesize bottomToolbar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        self.startCoordinate        = self.currentLocation.coordinate;
        self.destinationCoordinate  = CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
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
    
    [self addDefaultAnnotations];
    
    self.mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES];
//    
//    [self updateCourseUI];
//    
//    [self updateDetailUI];
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
//    NSMutableArray *items = [[NSMutableArray alloc] init];
//
//    [items addObject:];
//    [toolbar setItems:items animated:NO];

    [self.view addSubview:topToolbar];

   
}

-(void)initToolBar
{
    bottomToolbar = [[UIToolbar alloc] init];
    bottomToolbar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 60, [[UIScreen mainScreen] bounds].size.width, 60);
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back)];
    [items addObject:back];
    bottomToolbar.items = items;

    
    [self.view addSubview:bottomToolbar];

}


-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
}



- (void)addDefaultAnnotations
{
//    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
//    startAnnotation.coordinate = self.startCoordinate;
//    startAnnotation.title      = (NSString*)NavigationViewControllerStartTitle;
//    startAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
//    
//    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
//    destinationAnnotation.coordinate = self.destinationCoordinate;
//    destinationAnnotation.title      = (NSString*)NavigationViewControllerDestinationTitle;
//    destinationAnnotation.subtitle   = [NSString stringWithFormat:@"{%f, %f}", self.destinationCoordinate.latitude, self.destinationCoordinate.longitude];
//    
//    [self.mapView addAnnotation:startAnnotation];
//    [self.mapView addAnnotation:destinationAnnotation];
    
    self.annotations = [NSMutableArray array];
    //定义一个标注，放到annotations数组
    MAPointAnnotation *red = [[MAPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(39.911447, 116.406026);
    red.title  = @"Red";
    [self.annotations insertObject:red atIndex: 0];
    //定义第二个标注，放到annotations数组
    MAPointAnnotation *green = [[MAPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake(39.909698, 116.296248);
    green.title  = @"Green";
    //定义第三标注，放到annotations数组
    [self.annotations insertObject:green atIndex:1];
    MAPointAnnotation *purple = [[MAPointAnnotation alloc] init];
    purple.coordinate = CLLocationCoordinate2DMake(40.045837, 116.460577);
    purple.title  = @"Purple";
    [self.annotations insertObject:purple atIndex:2];
    //添加annotations数组中的标注到地图上
    [self.mapView addAnnotations: self.annotations];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    NSLog(@"@@@@@@");
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:navigationCellIdentifier];
            
            poiAnnotationView.canShowCallout = YES;
        }
            NSLog(@"??????");
        /* 起点. */
        if ([[annotation title] isEqualToString:(NSString*)NavigationViewControllerStartTitle])
        {
            NSLog(@"!!!!!!!!");
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



@end
