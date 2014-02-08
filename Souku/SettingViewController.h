//
//  SettingViewController.h
//  Souku
//
//  Created by Daniel Qiu on 2/1/14.
//  Copyright (c) 2014 zdwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


@property (strong,nonatomic) UITableView *settingTableView;

@property (strong,nonatomic) NSArray *settingItems;

@end
