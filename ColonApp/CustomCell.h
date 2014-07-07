//
//  CustomCell.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/3/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface CustomCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *customName;
@property (weak, nonatomic) IBOutlet UILabel *customDate;
@property (weak, nonatomic) IBOutlet UILabel *customTipo;
@property (weak, nonatomic) IBOutlet UIImageView *customDisponibilidad;

- (void) asignarImagenConLink:(NSString *)link;
- (void) asignarNombre: (NSString *)nombre;
- (void) asignarFecha: (NSString *)fecha;
- (void) asignarTipo: (NSString *)tipo;
- (void) asignariconoDisponibilidad: (NSString *)nombreIcono;
@end
