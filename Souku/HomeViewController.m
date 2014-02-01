//
//  HomeViewController.m
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"home";
        //self.tabBarItem.image = [UIImage imageNamed:@"homeItem"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"";
    self.mapButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemAction) target:(self) action:@selector(map)];
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:(self) action:@selector(refresh)];
    self.searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemSearch) target:(self) action:@selector(search)];
    NSArray *topRightButtons= [[NSArray alloc] initWithObjects:self.mapButton,self.refreshButton,self.searchButton, nil];
    self.navigationItem.rightBarButtonItems = topRightButtons;


    
}

-(void)map
{
    NSLog(@"change to map");
}

-(void)refresh
{
    NSLog(@"refresh");
}

-(void)search
{
    NSLog(@"search");
}

-(void)initTableView
{
    self.parkingLotTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.parkingLotTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.parkingLotTableView.delegate = self;
    self.parkingLotTableView.dataSource = self;
    [self.parkingLotTableView reloadData];
    
    self.view = self.parkingLotTableView;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
	// Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.parkArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"homeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.parkArray objectAtIndex:indexPath.row];
    return cell;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end