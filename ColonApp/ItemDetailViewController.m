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
    
    [self setearDelegate];
    
    [self cargarLink];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WebView Delegate methods.

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Comenzo a cargar el sitio");
    [spinner startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"Termino la carga del Sitio");
    [self.spinner stopAnimating];
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

#pragma mark - Inicializadores
- (void) setearDelegate{
    
    // Necesario para que funcionen los metodos del webview.
    NSLog(@"seteando delegate del webView");
    [webView setDelegate:self];
    
}

- (void) cargarLink{
    //El link me lo pasan del Segue anterior.
    NSURL *url = [NSURL URLWithString:link];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (IBAction)goBack:(id)sender{
    /*if ([self.webView canGoBack]) {
        [self.webView goBack];
        NSLog(@"Back Pressed");
    }*/
    
    //Refresh
    [self.webView reload];

}

@end
