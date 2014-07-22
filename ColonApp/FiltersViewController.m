//
//  FiltersViewController.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/21/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "FiltersViewController.h"
#import "AgendaFiltradaTableTableViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

@synthesize filtros;
@synthesize app;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Cargo referencia al appDelegate
    app = [[UIApplication sharedApplication] delegate];
    
    //Cargo los distintos tipos de filtros.
    [self cargarFiltros];
    
    //Color de fondo.
    self.view.backgroundColor = [UIColor darkGreyColorForCell];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];

    
    if ([segue.identifier isEqualToString:@"AgendaFiltradaSegue"]) {
        NSLog(@"Preparando los items para ser filtrados");
        AgendaFiltradaTableTableViewController *filteredView = [segue destinationViewController];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        NSLog(@"Seleccionado : %@", cell.textLabel.text);
        
        
        //Filtrando eventos cuyo tipo sea...
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"tipo contains[c] %@", cell.textLabel.text];
        
        filteredView.itemsAgendaFiltrados = [self.app.agenda filteredArrayUsingPredicate:resultPredicate];
        
        filteredView.title = [NSString stringWithFormat:@"%@", cell.textLabel.text];

    } else {
        NSLog(@"Se abrio un Segue no identificado");
       

    }
}


#pragma mark - filtros Lazy instantiation.
- (NSArray *) filtros{
    if (!filtros) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"clavesFiltros" ofType:@"plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            self.filtros = [[NSArray alloc] initWithContentsOfFile:path ];
            NSLog(@"Creado el array de filtros");
        } else{
            NSLog(@"No existe el archivo %@", path);
        }
    }
    NSLog(@"Devolviendo los filtros");
    return filtros;
}

#pragma mark - Methods
- (void) cargarFiltros{

}

#pragma mark -UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filtros.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString *claveFiltro;
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    claveFiltro = [self.filtros objectAtIndex:indexPath.row];
    
    //Fondo de las celdas gris oscuro.
    [cell setBackgroundColor:[UIColor darkGreyColorForCell]];

    cell.textLabel.text = claveFiltro;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
