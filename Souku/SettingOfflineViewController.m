//
//  SettingOfflineViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/8/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "SettingOfflineViewController.h"
#import <MAMapKit/MAOfflineMap.h>

NSString const *DownloadStageIsRunningKey = @"DownloadStageIsRunningKey";
NSString const *DownloadStageStatusKey    = @"DownloadStageStatusKey";
NSString const *DownloadStageInfoKey      = @"DownloadStageInfoKey";

@interface SettingOfflineViewController ()

@property(nonatomic,strong) UITableView *citysSelectTable;
@property(nonatomic,strong) UILabel *tableTitle;
@property(nonatomic,strong) NSArray *cityList;
@property(nonatomic,strong) UILabel *tableTitleLabel;
@property(nonatomic,strong) UILabel *tableLeftLabel;
@property(nonatomic,strong) UILabel *tableRightLabel;
@property (nonatomic, strong) NSMutableArray *downloadStages;



@end

@implementation SettingOfflineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
    [self getCities];
    [self initTableView];
    

}

- (void)getCities
{
     self.cityList = [MAOfflineMap sharedOfflineMap].offlineCities;
    
    self.downloadStages = [NSMutableArray arrayWithCapacity:self.cityList.count];
    
    for (int i = 0; i < self.cityList.count; i++)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [self.downloadStages addObject:dict];
    }

}

-(void)initTableView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat x =60;
    CGFloat y = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat viewWidth = screenWidth - 2*x;
    CGFloat viewHeight = screenHeight - 2*y-10;
    
    CGRect tableFrame = CGRectMake(x, y, viewWidth, viewHeight);
    self.citysSelectTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7){
        self.citysSelectTable.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    }
    [self.citysSelectTable setBackgroundView:[[UIView alloc]init] ];
    [self.citysSelectTable setBackgroundColor:[UIColor clearColor]];
    self.citysSelectTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.citysSelectTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.citysSelectTable.delegate = self;
    self.citysSelectTable.dataSource = self;
    self.citysSelectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.citysSelectTable reloadData];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.citysSelectTable];
    
    
    self.tableTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,viewHeight,viewWidth,20)];
    self.tableTitleLabel.text = @"全部";
    self.tableTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.view addSubview:self.tableTitleLabel];
    
    self.tableLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0.45*screenHeight,0.25*viewWidth,20)];
    self.tableLeftLabel.text = @"已选";
    self.tableLeftLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableLeftLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [self.view addSubview:self.tableLeftLabel];
    
    
    self.tableRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth-0.25*viewWidth,0.45*screenHeight,0.25*viewWidth,20)];
    self.tableRightLabel.text = @"未选";
    self.tableRightLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableRightLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
    [self.view addSubview:self.tableRightLabel];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10,0.3*screenHeight,0.1*viewWidth,60);
    [leftButton setImage:[UIImage imageNamed:@"leftButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftTable)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [self.view removeFromSuperview];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(screenWidth-0.15*viewWidth,0.3*screenHeight,0.1*viewWidth,60);
    [rightButton setImage:[UIImage imageNamed:@"rightButton"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightTable)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

- (void)leftTable
{
    
}

-(void)rightTable
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.cityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    }
    [self updateCell:cell city:self.cityList[indexPath.row] downloadStage:self.downloadStages[indexPath.row]];
    MAOfflineCity *selected = [self.cityList objectAtIndex:indexPath.row];
    cell.textLabel.text = selected.cityName;
    MAOfflineCity *city = self.cityList[indexPath.row];

    if (city.status == MAOfflineCityStatusInstalled)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
    
}



- (void)checkButtonTapped:(NSIndexPath *)indexPath
{
    
    if (indexPath == nil)
    {
        return;
    }

    MAOfflineCity *city = self.cityList[indexPath.row];
    if ([[MAOfflineMap sharedOfflineMap] isDownloadingForCity:city])
    {
        [self pause:indexPath];
    }
    else
    {
        [self download:indexPath];
    }
}

- (void)download:(NSIndexPath *)indexPath
{
    MAOfflineCity *city         = self.cityList[indexPath.row];
    
    NSMutableDictionary *stage  = self.downloadStages[indexPath.row];

    [[MAOfflineMap sharedOfflineMap] downloadCity:city downloadBlock:^(MAOfflineMapDownloadStatus downloadStatus, id info) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
            
            if (downloadStatus == MAOfflineMapDownloadStatusWaiting)
            {
                [stage setObject:[NSNumber numberWithBool:YES] forKey:DownloadStageIsRunningKey];
            }
            else if(downloadStatus == MAOfflineMapDownloadStatusProgress)
            {
                [stage setObject:info forKey:DownloadStageInfoKey];
            }
            else if(downloadStatus == MAOfflineMapDownloadStatusCancelled
                    || downloadStatus == MAOfflineMapDownloadStatusError
                    || downloadStatus == MAOfflineMapDownloadStatusFinished)
            {
                [stage setObject:[NSNumber numberWithBool:NO] forKey:DownloadStageIsRunningKey];
            }
            
            [stage setObject:[NSNumber numberWithInt:downloadStatus] forKey:DownloadStageStatusKey];
            
            UITableViewCell *cell = [self.citysSelectTable cellForRowAtIndexPath:indexPath];
            
            if (cell != nil)
            {
                [self updateCell:cell city:city downloadStage:stage];
            }
            
            
        });
    }];
}

- (void)updateCell:(UITableViewCell *)cell city:(MAOfflineCity *)city downloadStage:(NSDictionary *)downloadStage
{
   

    if (city.status == MAOfflineCityStatusInstalled)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text         = [self cellLabelTextForCity:city downloadStage:downloadStage];
    
    cell.detailTextLabel.text   = [self cellDetailTextForCity:city downloadStage:downloadStage];
}

- (NSString *)cellLabelTextForCity:(MAOfflineCity *)city downloadStage:(NSDictionary *)downloadStage
{
    NSString *labelText = nil;
    
    if ([[downloadStage objectForKey:DownloadStageIsRunningKey] boolValue])
    {
        labelText = city.cityName;
    }
    else
    {
        
        if (city.status == MAOfflineCityStatusCached)
        {
            labelText = [city.cityName stringByAppendingString:@"(缓存)"];
        }
        else
        {
            labelText = city.cityName;
        }
    }
    
    return labelText;
}


- (void)pause:(NSIndexPath *)indexPath
{
    [[MAOfflineMap sharedOfflineMap] pause:self.cityList[indexPath.row]];
}

- (NSIndexPath *)indexPathForSender:(id)sender event:(UIEvent *)event
{
    UIButton *button = (UIButton*)sender;
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![button pointInside:[touch locationInView:button] withEvent:event])
    {
        return nil;
    }
    
    CGPoint touchPosition = [touch locationInView:self.citysSelectTable];
    
    return [self.citysSelectTable indexPathForRowAtPoint:touchPosition];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    cell.selected = NO;
    
    
    [self checkButtonTapped:path];
}

- (NSString *)cellDetailTextForCity:(MAOfflineCity *)city downloadStage:(NSDictionary *)downloadStage
{
    NSString *detailText = nil;
    if (![[downloadStage objectForKey:DownloadStageIsRunningKey] boolValue])
    {
        if (city.status == MAOfflineCityStatusCached)
        {

            detailText = [NSString stringWithFormat:@"%lld/%lld", city.downloadedSize, city.size];
        }
        else if(city.status == MAOfflineCityStatusInstalled)
        {
            detailText = @"已安装";
        }
        else
        {
            detailText = [NSString stringWithFormat:@"大小:%lld", city.size];
        }
    }
    else
    {
        MAOfflineMapDownloadStatus status = [[downloadStage objectForKey:DownloadStageStatusKey] intValue];
        switch (status)
        {
                
            case MAOfflineMapDownloadStatusWaiting:
            {
                detailText = @"等待";
                
                break;
            }
            case MAOfflineMapDownloadStatusStart:
            {
                detailText = @"开始";
                
                break;
            }
            case MAOfflineMapDownloadStatusProgress:
            {
                NSDictionary *progressDict = [downloadStage objectForKey:DownloadStageInfoKey];
                
                long long recieved = [[progressDict objectForKey:MAOfflineMapDownloadReceivedSizeKey] longLongValue];
                long long expected = [[progressDict objectForKey:MAOfflineMapDownloadExpectedSizeKey] longLongValue];
                
                detailText = [NSString stringWithFormat:@"%lld/%lld(%.1f%%)", recieved, expected, recieved/(float)expected*100];
                break;
            }
            case MAOfflineMapDownloadStatusCompleted:
            {
                detailText = @"下载完成";
                break;
            }
            case MAOfflineMapDownloadStatusCancelled:
            {
                detailText = @"取消";
                break;
            }
            case MAOfflineMapDownloadStatusUnzip:
            {
                detailText = @"解压中";
                break;
            }
            case MAOfflineMapDownloadStatusFinished:
            {
                detailText = @"结束";
                
                break;
            }
            default:
            {
                detailText = @"错误";
                
                break;
            }
        }
    }
    return detailText;
}


@end
