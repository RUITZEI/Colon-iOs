//
//  AgendaFiltradaTableTableViewController.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/21/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemAgenda.h"
#import "AppDelegate.h"
#import "UIColor+RGBValue.h"
#import "Constants.h"

@interface AgendaFiltradaTableTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *itemsAgendaFiltrados;
@property (nonatomic, retain) ItemAgenda *itemAgenda;
@property (nonatomic, retain) AppDelegate *app;




@end
