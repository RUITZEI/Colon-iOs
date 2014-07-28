//
//  ItemAgenda.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "ItemAgenda.h"

@implementation ItemAgenda

@synthesize nombre, tipo, fecha, link, logoId, disponibilidad, saleDate, itemId;


- (NSString *) getFechaDeVentaConvertida{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //Formato ejemplo: 2014-07-29 10:00 AM
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm a"];
    
    //Paso el string a fecha.
    NSDate *fechaFormateada = [dateFormatter dateFromString: self.saleDate];
    
    //Le cambio el formato para que devuelva:   25/05 a las 20:00hs
    [dateFormatter setDateFormat:@"dd'/'M 'a las 'h:mm'hs'"];
    
    return ([dateFormatter stringFromDate:fechaFormateada]);
}

@end
