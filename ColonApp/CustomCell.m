//
//  CustomCell.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/3/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) asignarImagenConLink:(NSString *)link{
    NSString *nombreDeLaImagen;
    
    if ( link == nil) {
        nombreDeLaImagen = [NSString stringWithFormat:@"default_logo.jpg"];
        self.customImage.image = [UIImage imageNamed:nombreDeLaImagen];
    } else {
        [self.customImage setImageWithURL:[NSURL URLWithString:link] placeholderImage:[UIImage imageNamed:@"default_logo.jpg"]];
    }
}

- (void) asignarNombre: (NSString *)nombre{
    self.customName.text = nombre;
}

- (void) asignarFecha: (NSString *)fecha{
    self.customDate.text = fecha;
}

- (void) asignarTipo: (NSString *)tipo{
    self.customTipo.text = tipo;
}

- (void) asignariconoDisponibilidad: (NSString *)nombreIcono{
    self.customDisponibilidad.image = [UIImage imageNamed:nombreIcono];
}

@end
