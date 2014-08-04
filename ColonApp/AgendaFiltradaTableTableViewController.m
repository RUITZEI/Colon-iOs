//
//  AgendaFiltradaTableTableViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/21/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "AgendaFiltradaTableTableViewController.h"
#import "CustomCell.h"
#import "ItemDetailViewController.h"


@interface AgendaFiltradaTableTableViewController ()

@end

@implementation AgendaFiltradaTableTableViewController

@synthesize itemsAgendaFiltrados;
@synthesize itemAgenda;
@synthesize app;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Referencia al app delegate.
    app = [[UIApplication sharedApplication] delegate];
    
    //Color de fondo.
    self.view.backgroundColor = [UIColor darkGreyColorForCell];

    NSLog(@"Cantidadd Items a mostrar: %i", self.itemsAgendaFiltrados.count);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.itemsAgendaFiltrados.count != 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No hay eventos disponibles.";
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Ojo, este numero hay que ponerlo manualmente para que no se cague con el searchviw.
    return 105;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsAgendaFiltrados count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    

    CustomCell *cell = (CustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    
    itemAgenda = [self.itemsAgendaFiltrados objectAtIndex:indexPath.row];

    [cell asignarNombre:itemAgenda.nombre];
    [cell asignarTipo:itemAgenda.tipo];
    [cell asignarFecha:itemAgenda.fecha];
    [cell asignarImagenConLink:itemAgenda.logoId];
    [cell asignariconoDisponibilidad:[app.tablaDisponibilidad valueForKey:itemAgenda.disponibilidad]];
    
    
    cell.backgroundColor = (indexPath.row%2)
    ? [UIColor darkGreyColorForCell]
    : [UIColor blackColorForCell];
    
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    itemAgenda = [self.itemsAgendaFiltrados objectAtIndex:indexPath.row];
    
    
    BOOL tieneAsientosDisponibles = ![itemAgenda.disponibilidad isEqualToString:@"S"];
    BOOL estaEnVenta = ([itemAgenda.saleDate length] < 1 );
    
    if ( (tieneAsientosDisponibles) && (estaEnVenta) ) {
        [self performSegueWithIdentifier:@"detailSegue" sender:nil];
        
    } else  if (! tieneAsientosDisponibles){
        NSLog(@"No Hay Asientos Disponibles");
        
    } else if (! estaEnVenta){
        NSLog(@"No esta a la venta");
    }
}



#pragma mark - Miscelaneos

- (void) asignarIconoEnCelda:(CustomCell *)celda conDisponibilidad:(NSString *)disponibilidad{

    celda.customDisponibilidad.image = [UIImage imageNamed: [app.tablaDisponibilidad valueForKey:disponibilidad]];
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        NSLog(@"Abriendo detalles para la funcion: %@", itemAgenda.nombre);
        ItemDetailViewController *detailView = [segue destinationViewController];
        detailView.link = [NSString stringWithFormat:@"%@%@",COMPRA_COLON, itemAgenda.link];
        detailView.hidesBottomBarWhenPushed = YES;
        
    } else {
        NSLog(@"Se abrio un Segue no identificado");
    }
}




@end
