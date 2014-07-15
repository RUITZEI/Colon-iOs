//
//  ItemAgenda.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemAgenda : NSObject

@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) NSString *tipo;
@property (nonatomic, retain) NSString *fecha;
@property (nonatomic, retain) NSString *link;
@property (nonatomic, retain) NSString *logoId;
@property (nonatomic, retain) NSString *disponibilidad;
@property (nonatomic, retain) NSString *saleDate;
@property (nonatomic, readwrite) NSInteger itemId;



@end
