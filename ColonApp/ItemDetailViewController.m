//
//  ItemDetailViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/7/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "ItemDetailViewController.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController

@synthesize webView;
@synthesize link;
@synthesize spinner;

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
    NSLog(@"seteando delegate del webView");
    [webView setDelegate:self];
    
    // Do any additional setup after loading the view.
    //NSString *colon = [NSString stringWithFormat:@"https://www.tuentrada.com/extrasTuE/colon/tour/tour.html"];
    
    NSURL *url = [NSURL URLWithString:link];
    //NSURL *url = [NSURL URLWithString:colon];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WebView Delegate methods.

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Comenzo a cargar el sitio");
    //spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //spinner.center = CGPointMake(160, 240);
    //spinner.tag = 12;
    [spinner startAnimating];
    //[self.view addSubview:spinner];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"Termino la carga del Sitio");
    [self.spinner stopAnimating];
    //[self.spinner removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Error cargando el sitio");
    [self.spinner stopAnimating];
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
