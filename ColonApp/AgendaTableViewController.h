//
//  AgendaTableViewController.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/3/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemAgenda.h"
#import "AppDelegate.h"
#import "UIColor+RGBValue.h"


@interface AgendaTableViewController : UITableViewController

@property (nonatomic, retain) AppDelegate *app;
@property (nonatomic, retain) ItemAgenda *itemAgenda;

@end