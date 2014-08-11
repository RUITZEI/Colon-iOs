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
    
    [self.forwardButton setEnabled:NO];
    [self.backButton setEnabled: NO];
        
    [self setearDelegate];
    
    [self cargarSpinner];
    
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
    [self actualizarBotones];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Error cargando el sitio");
    [self.spinner stopAnimating];
    [self actualizarBotones];
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

- (UIActivityIndicatorView *) spinner{
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    return spinner;
}

- (void) cargarLink{
    //El link me lo pasan del Segue anterior.
    NSURL *url = [NSURL URLWithString:link];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void) cargarSpinner{
    float navBarHeight = [[self.navigationController navigationBar] frame ].size.height;
    float tabBarHeight = [[self.tabBarController tabBar] frame].size.height;
    
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2.0, ( self.view.frame.size.height - navBarHeight - tabBarHeight) /2.0);
    
    spinner.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = [[self view] tintColor];
    [self.view addSubview:spinner];
}



#pragma mark - Bottom bar Methods
- (IBAction)goBack:(id)sender{
    NSLog(@"Back Pressed");
    
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)goForward:(id)sender{
    NSLog(@"Forward Pressed");
    
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

-(IBAction)reloadSite:(id)sender{
    
    [self.webView reload];
}


/*
 Cada vez que termina de cargarse una pagina se fija si deberian estar ENABLED los botones de
 back y forward. Refresh siempre está disponible.
 */
- (void) actualizarBotones{
    [self.forwardButton setEnabled:NO];
    [self.backButton setEnabled: NO];
    
    if (webView.canGoBack){
        [self.backButton setEnabled:YES];
    }
         
    if (webView.canGoForward){
        [self.forwardButton setEnabled:YES];
    }
}

@end
