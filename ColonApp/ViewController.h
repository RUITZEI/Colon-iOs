//
//  ViewController.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ItemAgenda.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) AppDelegate *app;
@property (nonatomic, retain) ItemAgenda *itemAgenda;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
