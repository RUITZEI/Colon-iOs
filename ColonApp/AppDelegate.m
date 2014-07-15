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

@implementation AppDelegate

@synthesize agenda;
@synthesize tablaDisponibilidad;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
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
        NSLog(@"Nombre: %@ \n Fecha: %@ \n Link: %@ \n" , unItem.nombre, unItem.fecha, unItem.link);
    }else{
        NSLog(@"No Funciono...");
    }
    
    [self inicializarTablaDisponibilidad];
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    
    //[self.window makeKeyAndVisible];
        
    
    
    // Override point for customization after application launch.
    return YES;
}


// Carga el nombre de la imagen correspondiente a cada Valor en un Hash.
- (void) inicializarTablaDisponibilidad{
    
    if (!tablaDisponibilidad) {
        tablaDisponibilidad = [[NSMutableDictionary alloc] initWithCapacity:5];
        
        [tablaDisponibilidad setValue:@"availability_excellent.png" forKey:@"E"];
        [tablaDisponibilidad setValue:@"availability_good.png" forKey:@"G"];
        [tablaDisponibilidad setValue:@"availability_limited.png" forKey:@"L"];
        [tablaDisponibilidad setValue:@"availability_sold_out.png" forKey:@"S"];
    }
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

@end
