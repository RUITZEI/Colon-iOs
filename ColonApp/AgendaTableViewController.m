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
@synthesize searchBar;

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
    
    
    [self cargarPrograma];
    
    [self agregarPullToRefresh];
    
    
    //Esto cambia el color del fondo de la tableView.
    self.view.backgroundColor = [UIColor darkGreyColorForCell];

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
    
    
    
    //Selector Color.
    
    /*
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView]; */
    

    [cell asignarNombre:itemAgenda.nombre];
    [cell asignarTipo:itemAgenda.tipo];
    [cell asignarFecha:itemAgenda.fecha];
    [cell asignarImagenConLink:itemAgenda.logoId];
    [cell asignariconoDisponibilidad:[app.tablaDisponibilidad valueForKey:itemAgenda.disponibilidad]];
    
    
    cell.backgroundColor = (indexPath.row%2)
    ? [UIColor darkGreyColorForCell]
    : [UIColor blackColorForCell];
    
    
     
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //cell.accessoryView.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchDisplayController.isActive) {
        itemAgenda = [resultadosBusqueda objectAtIndex:indexPath.row];
    } else {
        itemAgenda = [self.app.agenda objectAtIndex:indexPath.row];
    }
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Ojo, este numero hay que ponerlo manualmente para que no se cague con el searchviw.
    return 105;
}

#pragma mark - Miscelaneos

- (void) asignarIconoEnCelda:(CustomCell *)celda conDisponibilidad:(NSString *)disponibilidad{
    
    celda.customDisponibilidad.image = [UIImage imageNamed: [app.tablaDisponibilidad valueForKey:disponibilidad]];
    
}

#pragma mark - Search Filter methods
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
    
    
    
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        NSLog(@"Abriendo detalles para la funcion: %@", itemAgenda.nombre);
        ItemDetailViewController *detailView = [segue destinationViewController];
        detailView.link = [NSString stringWithFormat:@"%@%@",COMPRA_COLON, itemAgenda.link];

    } else if ([segue.identifier isEqualToString:@"filterSegue"]){
        NSLog(@"Abriendo los filtros");
    } else {
         NSLog(@"Se abrio un Segue no identificado");
    }
}



#pragma mark - Open Filters

- (IBAction)openFilters:(id)sender{
    NSLog(@"Filter button Clicked");
}

- (void) parsearXML{
    NSLog(@"Parseando en segundo plano desde Agenda");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.app parsear];
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Termino");
            [self.tableView reloadData];
            if ( [self.refreshControl isRefreshing ] ){
                [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:1.5];
            }
        });
    });
}

- (void)stopRefresh
{
    NSLog(@"Refresh stopped.");
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

#pragma mark - Inicializadores

/*    Si llegue a bajarme la agenda, la muestro, sino vuelvo
      a intentar descargarla en segundo plano y actualizo la table.
 */
- (void) cargarPrograma{
    if ([self.app.agenda count] < 1) {
        NSLog(@"No se habia parseado");
        [self parsearXML];
    } else {
        NSLog(@"Ya se habia parseado el RSS \n Recargo la tabla");
        [self.tableView reloadData];
    }
}

- (void) agregarPullToRefresh{
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(parsearXML)
      forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
}


@end
