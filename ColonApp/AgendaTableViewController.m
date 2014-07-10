//
//  AgendaTableViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/3/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "AgendaTableViewController.h"
#import "CustomCell.h"
#import "ItemDetailViewController.h"

@interface AgendaTableViewController ()


@end

@implementation AgendaTableViewController

@synthesize app;
@synthesize itemAgenda;
@synthesize resultadosBusqueda;

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
    
    app = [[UIApplication sharedApplication] delegate];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [resultadosBusqueda count];
        
    } else {
        return [self.app.agenda count];
    }
//    return [self.app.agenda count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCell *cell = (CustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        itemAgenda = [resultadosBusqueda objectAtIndex:indexPath.row];
    } else {
        itemAgenda = [app.agenda objectAtIndex:indexPath.row];
    }
    
    
    
    //itemAgenda = [app.agenda objectAtIndex:indexPath.row];

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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Ojo, este numero hay que ponerlo manualmente para que no se cague con el searchviw.
    return 105;
}

#pragma mark - Miscelaneos

- (void) asignarIconoEnCelda:(CustomCell *)celda conDisponibilidad:(NSString *)disponibilidad{
    
    celda.customDisponibilidad.image = [UIImage imageNamed: [app.tablaDisponibilidad valueForKey:disponibilidad]];
    
}

#pragma mark - Search Filers methods
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nombre contains[c] %@", searchText];
    resultadosBusqueda = [self.app.agenda filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    
    
    //NSLog(@"Escribi: %@", searchString);
    
    return YES;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    
    
    // Si estaba activa la busqueda hay que cambiar el indexPath para que no
    // quede con las referencias cambiadas.
    
    if (self.searchDisplayController.active) {
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        itemAgenda = [resultadosBusqueda objectAtIndex:indexPath.row];
        
    } else {
        
        indexPath = [self.tableView indexPathForSelectedRow];
        itemAgenda = [app.agenda objectAtIndex:indexPath.row];
    }
    
    
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        NSLog(@"Abriendo detalles para la funcion: %@", itemAgenda.nombre);
        ItemDetailViewController *detailView = [segue destinationViewController];
        detailView.link = [NSString stringWithFormat:@"%@%@",COMPRA_COLON, itemAgenda.link];

    } else{
        NSLog(@"Se abrio un Segue no identificado");
    }
}


@end
