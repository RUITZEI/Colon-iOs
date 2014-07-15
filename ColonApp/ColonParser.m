//
//  ColonParser.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/2/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "ColonParser.h"
#import "Constants.h"

@implementation ColonParser

- (id) initParser{
    
    if (self == [super init]){
        
        app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
    }
    
    return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"results"]) {
        
        app.agenda = [[NSMutableArray alloc] init];
        
    } else if([elementName isEqualToString:@"event"]) {
        
        itemAgenda = [[ItemAgenda alloc] init];
        itemAgenda.itemId = [[attributeDict objectForKey:@"count"] integerValue];
    }
    
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    if (!currentElementValue){
        currentElementValue = [[NSMutableString alloc] initWithString:string];
    }else {
        [currentElementValue appendString:string];
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"results"]){
        return;
    }
    
    if ([elementName isEqualToString:@"event"]) {
        [app.agenda addObject:itemAgenda];
        
        itemAgenda = nil;
    }else{
        
        //[itemAgenda setValue:currentElementValue forKey:elementName];
        
        //currentElementValue = nil;
        
        if ([elementName isEqualToString:ATT_NOMBRE]){
            [itemAgenda setValue:currentElementValue forKey:@"nombre"];
            
        }else if([elementName isEqualToString:ATT_TIPO]){
            [itemAgenda setValue:currentElementValue forKey:@"tipo"];
            
        }else if ([elementName isEqualToString:ATT_FECHA]) {
            [itemAgenda setValue:currentElementValue forKey:@"fecha"];
            
        }else if ([elementName isEqualToString:ATT_DISPONIBILIDAD]){
            [itemAgenda setValue:currentElementValue forKey:@"disponibilidad"];
            
        }else if ([elementName isEqualToString:ATT_LINK]){
            [itemAgenda setValue:currentElementValue forKey:@"link"];
            
        }else if ([elementName isEqualToString:ATT_LOGOID]){
            [itemAgenda setValue:currentElementValue forKey:@"logoId"];
        }
        else if ([elementName isEqualToString:ATT_SALE_DATE]){
            [itemAgenda setValue:currentElementValue forKey:@"saleDate"];
        }
        
        
        currentElementValue = nil;
        
    }
    /*
    
    if ([elementName isEqualToString: ATT_NOMBRE]){
        nombre = leerNombre(parser);
    } else if ([elementName isEqualToString: ATT_TIPO]){
        tipo = leerTipo(parser);
    } else if ([elementName isEqualToString: ATT_FECHA]){
        fecha = leerFecha(parser);
    } else if ([elementName isEqualToString: ATT_LINK]){
        link = leerLink(parser);
    }else if ([elementName isEqualToString: ATT_LOGOID]){
        logoId = leerLogoId(parser);
    }else if ([elementName isEqualToString: ATT_DISPONIBILIDAD]){
        disponibilidad = leerDisponibilidad(parser);
    }else{
        skip(parser);
    }
     
     */
}

@end

