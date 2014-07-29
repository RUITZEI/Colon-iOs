//
//  FiltersViewController.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/21/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FiltersViewController : UITableViewController

@property (nonatomic, retain) AppDelegate *app;
@property (nonatomic, strong) NSDictionary *filtros;
@property (nonatomic, strong) NSArray *sectionTitles;


@end
