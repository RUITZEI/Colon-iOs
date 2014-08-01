//
//  TourVirtualViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/15/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "TourVirtualViewController.h"
#import "Constants.h"

@interface TourVirtualViewController ()

@end

@implementation TourVirtualViewController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (IBAction)openLinkWithSafari:(id)sender{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:COLON_360]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
