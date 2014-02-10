//
//  LocationDetailViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/3/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "LocationDetailViewController.h"

@interface LocationDetailViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NavigationViewController *navigationViewController;



@property (strong, nonatomic) UILabel *poiNameLabel;
@property (strong, nonatomic) UILabel *addressTitleLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *phoneTileLabel;
@property (strong, nonatomic) UILabel *phoneLabel;

@property (strong, nonatomic) UIButton *navigationButton;
@property (strong, nonatomic) UIButton *favouriteButton;
@property (strong, nonatomic) UIButton *shareButton;

@end

@implementation LocationDetailViewController

@synthesize poi = _poi;
@synthesize tableView = _tableView;
@synthesize poiNameLabel;
@synthesize addressTitleLabel;
@synthesize addressLabel;
@synthesize phoneLabel;
@synthesize phoneTileLabel;
@synthesize navigationButton;
@synthesize favouriteButton;
@synthesize shareButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTitle];
    [self initContent];
    [self initButton];
}

- (void)initTitle
{

    self.navigationItem.title= @"详细信息";
}


-(void)initContent
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    poiNameLabel = [[UILabel alloc]init];
    poiNameLabel.numberOfLines = 0;
    poiNameLabel.text = self.poi.name;
    poiNameLabel.frame = CGRectMake(30, 50, screenWidth-2*30, 20);
    [poiNameLabel setFont:[UIFont systemFontOfSize:20]];
    [poiNameLabel sizeToFit];

    [self.view addSubview:poiNameLabel];
    
    
    addressTitleLabel = [[UILabel alloc] init];
    addressTitleLabel.numberOfLines = 0;
    addressTitleLabel.text = @"地  址：";
    [addressTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    addressTitleLabel.frame = CGRectMake(poiNameLabel.frame.origin.x,
                                         poiNameLabel.frame.origin.y+poiNameLabel.frame.size.height+20,
                                         100, 20);
    [addressTitleLabel sizeToFit];
    [self.view addSubview:addressTitleLabel];

    

    addressLabel = [[UILabel alloc]init];
    addressLabel.numberOfLines = 0;
    addressLabel.text = self.poi.address;
    addressLabel.frame = CGRectMake(addressTitleLabel.frame.origin.x+addressTitleLabel.frame.size.width,
                                         addressTitleLabel.frame.origin.y,
                                         screenWidth-2*addressTitleLabel.frame.origin.x-addressTitleLabel.frame.size.width
                                        , 20);
    
    [self.addressLabel sizeToFit];
    [self.view addSubview:self.addressLabel];

    
    phoneTileLabel = [[UILabel alloc]init];
    phoneTileLabel.numberOfLines = 0;
    phoneTileLabel.text = @"电  话：";
    [phoneTileLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    
    phoneTileLabel.frame = CGRectMake(addressTitleLabel.frame.origin.x,
                                   addressLabel.frame.origin.y+addressLabel.frame.size.height+20,
                                   100, 20);
    [phoneTileLabel sizeToFit];
    [self.view addSubview:phoneTileLabel];
    
    
    phoneLabel = [[UILabel alloc]init];
    phoneLabel.numberOfLines = 0;
    
    
    
    
    NSArray *phoneArray = [self.poi.tel componentsSeparatedByString:@";"];
    NSString *phone;
    if(phoneArray.count < 1)
    {
        phone = @"无";
    }
    else
    {
        phone = [phoneArray objectAtIndex:0];
        if(phoneArray.count > 1)
        {
            for(int i = 1; i < phoneArray.count;i++)
            {
                NSString *temp = [@"\n" stringByAppendingString:phoneArray[i]];
                [phone stringByAppendingString:temp];
            }
        }
    }
    phoneLabel.text = phone;
    phoneLabel.frame = CGRectMake(phoneTileLabel.frame.origin.x+phoneTileLabel.frame.size.width,
                                      phoneTileLabel.frame.origin.y,
                                      screenWidth-2*phoneTileLabel.frame.origin.x-phoneTileLabel.frame.size.width, 20);
    [phoneLabel sizeToFit];
    [self.view addSubview:phoneLabel];
    
    
}


-(void)initButton
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat buttonH = 75;
    CGFloat buttonW = 75;
    CGFloat buttonY = screenHeight-200;
    
    
    navigationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [navigationButton setImage:[UIImage imageNamed:@"navigationButton"] forState:UIControlStateNormal];
    navigationButton.frame = CGRectMake((screenWidth-3*buttonW)/4, buttonY, buttonW, buttonH);
    [self.view addSubview:navigationButton];
    
    favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favouriteButton setImage:[UIImage imageNamed:@"favouriteButton"] forState:UIControlStateNormal];
    favouriteButton.frame = CGRectMake(buttonW+2*(screenWidth-3*buttonW)/4, buttonY, buttonW, buttonH);
    [self.view addSubview:favouriteButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setImage:[UIImage imageNamed:@"shareButton"] forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(2*buttonW+3*(screenWidth-3*buttonW)/4, buttonY, buttonW, buttonH);
    [self.view addSubview:shareButton];
    
    [self.navigationButton addTarget:self action:@selector(pushToNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.favouriteButton addTarget:self action:@selector(favourite) forControlEvents:UIControlEventTouchUpInside];

}


-(void)pushToNavigation
{
    self.navigationViewController = [[NavigationViewController alloc] init];
    self.navigationViewController.poi = self.poi;
    [[self navigationController] pushViewController:self.navigationViewController animated:YES];
}

-(void)favourite
{
    LocationDataController *locationDataController = [[LocationDataController alloc]init];
    [locationDataController initializeDefaultDataList];
    
    if([locationDataController containsPOI:self.poi])
    {
        [locationDataController removePOI:self.poi];
    }
    else
    {
        [locationDataController addPOI:self.poi];
    }
    
}








@end
