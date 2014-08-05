//
//  Colon360ViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/11/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "ProgramaViewController.h"

@interface ProgramaViewController ()

@end

@implementation ProgramaViewController

@synthesize webView;
@synthesize spinner;
@synthesize imagenError;

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
    // Do any additional setup after loading the view.
    NSLog(@"seteando delegate del Programa Colon");
    [webView setDelegate:self];
    
    self.spinner.hidesWhenStopped = YES;
    
    [self cargarPrograma];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate methods.

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    NSLog(@"Comenzo a cargar el sitio");
    [self.spinner startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    NSLog(@"Termino la carga del Sitio");
    [self.spinner stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"Error cargando el sitio");
    [self.spinner stopAnimating];
    [self mostrarImagenError];
    //[self mostrarBotonError];
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

#pragma mark - Lazy Instantiation
- (UIImageView *) imagenError{
    if (!imagenError){
        imagenError = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [imagenError setImage: [UIImage imageNamed:@"programa-actualizar"]];
    }
    
    return imagenError;
}


- (void) mostrarImagenError{
    
    [self.imagenError sizeToFit];
    [self.imagenError setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2.0)];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clicked)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    self.imagenError.userInteractionEnabled = YES;
    self.imagenError.contentMode = UIViewContentModeScaleAspectFill;
    [self.imagenError addGestureRecognizer:tapGestureRecognizer];
    
    [self.view addSubview:imagenError];
}


#pragma mark - Link en Browser
- (void) cargarPrograma{
    NSURL *url = [NSURL URLWithString:PROGRAMA_COLON];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void) clicked {
    NSLog(@"Intentando Carga programa nuevamente...");
    [self.imagenError removeFromSuperview];
//    [self.view addSubview:self.spinner];
    [self cargarPrograma];
}

@end
