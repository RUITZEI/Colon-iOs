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
@synthesize spinner;

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
    
    [self agregarPullToRefresh];
    
    [self agregarSpinner];

    [self cargarAgenda];
    
    //Esto cambia el color del fondo de la tableView.
    self.view.backgroundColor = [UIColor darkGreyColorForCell];
    [self.searchDisplayController.searchResultsTableView setBackgroundColor:[UIColor darkGreyColorForCell]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // si existen elementos no hago nada.
    if (self.app.agenda) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [self.searchDisplayController.searchBar setHidden:NO];
        self.tableView.backgroundView = nil;
        return 1;
        
    } else {
        /* Si llego aca es porque la agenda NO tiene elementos.
           Puede ser que todavia este parseando
           O directamente que haya fallado el parse.
         */
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.searchDisplayController.searchBar setHidden:YES];
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [resultadosBusqueda count];
        
    } else {
        return [self.app.agenda count];
    }
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
        [self mostrarAlertaConFechaDeVenta];
        NSLog(@"No esta a la venta");
        NSLog(@"Las entradas salen a la venta el %@",itemAgenda.getFechaDeVentaConvertida);
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
        detailView.hidesBottomBarWhenPushed = YES;
        
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

#pragma mark - Lazy Instantiation
- (UIActivityIndicatorView *)spinner{
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    
    return spinner;
}

#pragma mark - Inicializadores

/*    Si llegue a bajarme la agenda, la muestro, sino vuelvo
      a intentar descargarla en segundo plano y actualizo la table.
 */
- (void) cargarAgenda{
    if (!self.app.agenda) {
        NSLog(@"No estaba parseado");
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
    self.refreshControl.backgroundColor = [UIColor whiteColor];
}

- (void) agregarSpinner{
    float navBarHeight = [[self.navigationController navigationBar] frame ].size.height;
    float tabBarHeight = [[self.tabBarController tabBar] frame].size.height;
    
    self.spinner.center = CGPointMake(self.view.frame.size.width / 2.0, ( self.view.frame.size.height - navBarHeight - tabBarHeight) /2.0);
    
    self.spinner.autoresizingMask =
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin;
    
    self.spinner.hidesWhenStopped = YES;
    self.spinner.color = [[self view] tintColor];
    [self.view addSubview:spinner];
    
    [self.spinner startAnimating];
}

#pragma mark - Metodos

- (void) parsearXML{
    NSLog(@"Parseando en segundo plano desde Agenda");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL pudoParsear = [self.app parsear];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.spinner stopAnimating];

            if ( [self.refreshControl isRefreshing ] ){
                NSLog(@"Termino de actualizar via Pull-To-Refresh");
                [self performSelector:@selector(stopRefresh) withObject:nil afterDelay:0.5];
            } else {
                NSLog(@"Termino de actualizar por via normal.");
                [self actualizarTable:pudoParsear];
            }
        });
    });
}

- (void)stopRefresh
{
    NSLog(@"Termino Pull-down refresh");
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

- (void) actualizarTable: (BOOL) pudoParsear{
    [self.spinner stopAnimating];

    if (pudoParsear) {
        NSLog(@"Parseo Bien");
        [self.tableView reloadData];
    } else {
        NSLog(@"Error en el parseo, muestro mensaje");
        [self mostrarMensajeActualizar];
    }
}


#pragma mark - UIX methods
- (void) mostrarMensajeActualizar{
    
    //Creo una view que ocupe toda la pantalla
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    //Creo un icono para agregarselo a la view
    UIImageView *icono = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) ];
    [icono setImage: [UIImage imageNamed:@"agenda-flecha.png"]];
    [icono sizeToFit];
    //[icono setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /4)];
    [icono setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /3)];
    
    // Creo un mensaje diciendo que actualice.
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    messageLabel.text = @"Deslizar para actualizar...";
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    //        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
    [messageLabel sizeToFit];
    //[messageLabel setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /4 + icono.frame.size.height * 1.5)];
    [messageLabel setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /3 + icono.frame.size.height * 1.5)];
    
    
    //Agrego las views a la view principal.
    [customView addSubview:icono];
    [customView addSubview:messageLabel];
    
    //Lo pongo de fondo.
    self.tableView.backgroundView = customView;
}

- (void) mostrarAlertaConFechaDeVenta{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entradas no disponibles"
                                                    message: [NSString stringWithFormat:@"Las localidades salen a la venta el %@",itemAgenda.getFechaDeVentaConvertida ]
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}


@end
