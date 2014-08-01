//
//  AppDelegate.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *agenda;
@property (nonatomic, strong) NSMutableDictionary *tablaDisponibilidad;
@property (nonatomic, assign) BOOL estaParseando;

- (BOOL) parsear;
- (void) backgroundParser;

@end
