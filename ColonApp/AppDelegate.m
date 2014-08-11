//
//  AppDelegate.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "ColonParser.h"
#import <Parse/Parse.h>

@implementation AppDelegate


@synthesize agenda;
@synthesize tablaDisponibilidad;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Teclado oscuro -> por defecto es blanquito.
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    [self inicializarTabs];
    
    //[self.window makeKeyAndVisible];
    
    
    //Cosas del Parse...
    [Parse setApplicationId:@"VMAZUcL4dQslhLyBBuQui4Shhv7igRdbUXqR0Z3w"
                  clientKey:@"sgu55tEFLOXmu3nEdndTDNPHRUwDWcfaHRA1Co7N"];
    
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];

    
    return YES;
    
}

- (void) backgroundParser{
    NSLog(@"Intentando parsear desde AppDelegate");
    [NSThread detachNewThreadSelector:@selector(parsear) toTarget:self withObject:nil];
}

- (BOOL) parsear{
    
    NSURL *url = [[NSURL alloc] initWithString:URL_RSS_COLON];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    
    ColonParser *colonParser = [[ColonParser alloc] initParser];
    
    [xmlParser setDelegate:colonParser];
    
    BOOL worked = [xmlParser parse];
    
    if (worked){
        NSLog(@" # items agenda: %i", [agenda count]);
        ItemAgenda *unItem = [[ItemAgenda alloc] init];
        unItem = [ agenda objectAtIndex:1];
        NSLog(@"Segundo Elemento: \n Nombre: %@ \n Fecha: %@ \n Link: %@ \n Imagen: %@ \n Tipo: %@" , unItem.nombre, unItem.fecha, unItem.link, unItem.logoId, unItem.tipo);
    }else{
        NSLog(@"No Funciono...");
    }
    
    return worked;
    
}


- (NSDictionary *) tablaDisponibilidad{
// Carga el nombre de la imagen correspondiente a cada Valor en un Hash.
    
    if (!tablaDisponibilidad){
        tablaDisponibilidad = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        [tablaDisponibilidad setValue:@"availability_excellent.png" forKey:@"E"];
        [tablaDisponibilidad setValue:@"availability_good.png" forKey:@"G"];
        [tablaDisponibilidad setValue:@"availability_limited.png" forKey:@"L"];
        [tablaDisponibilidad setValue:@"availability_sold_out.png" forKey:@"S"];
    }
    return tablaDisponibilidad;
}


- (void) inicializarTabs{
   //1- Programa     2-Cartelera      3- 360
    
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabCartelera = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabPrograma = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabTour = [tabBar.items objectAtIndex:2];
    
    //Color de fondo de las imagenes. Le pone un tint azul por default.
    if ([UITabBar instancesRespondToSelector:@selector(setSelectedImageTintColor:)]) {
        [tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    }
    
    
    (void) [tabCartelera initWithTitle:@"Cartelera" image:[UIImage imageNamed:@"icono-cartelera.png"]  selectedImage:[UIImage imageNamed:@"icono-cartelera_activo.png"]];
    (void)[tabPrograma initWithTitle:@"Programa" image:[UIImage imageNamed:@"icono-programa.png"] selectedImage:[UIImage imageNamed:@"icono-programa_activo.png"]];
    (void) [tabTour initWithTitle:@"Colón 360º" image:[UIImage imageNamed:@"icono-360.png"]  selectedImage:[UIImage imageNamed:@"icono-360_activo.png"]];
    
    
    // Change the title color of tab bar items
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
[[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];

    
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
