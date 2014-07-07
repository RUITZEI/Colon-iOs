//
//  ColonParser.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ItemAgenda.h"

@interface ColonParser : NSObject <NSXMLParserDelegate>{
    AppDelegate *app;
    ItemAgenda *itemAgenda;
    NSMutableString *currentElementValue;
}

- (id) initParser;

@end
