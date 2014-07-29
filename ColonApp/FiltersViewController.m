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


@synthesize app;
@synthesize filtros;
@synthesize sectionTitles;

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
        
        
        //Filtrando eventos cuyo tipo o nombre sea...
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"(tipo contains[c] %@) or (nombre contains[c] %@)", cell.textLabel.text, cell.textLabel.text];
        
        filteredView.itemsAgendaFiltrados = [self.app.agenda filteredArrayUsingPredicate:resultPredicate];
        
        filteredView.title = [NSString stringWithFormat:@"%@", cell.textLabel.text];

    } else {
        NSLog(@"Se abrio un Segue no identificado");
       

    }
}


#pragma mark - filtros Lazy instantiation.
/*
 Para agregar nuevos filtros, solo hay que agregar en el archivo dicArray la categoria a la cual
 perteneceria y el nuevo filtro.
 */
- (NSDictionary *) filtros{
    if (!filtros) {
        NSString *path = [[NSBundle mainBundle] pathForResource:
                          @"dicArray" ofType:@"plist"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            self.filtros = [[NSDictionary alloc] initWithContentsOfFile:path ];
            NSLog(@"Creado el Diccio de filtros");
        } else{
            NSLog(@"No existe el archivo %@", path);
        }
    }
    //NSLog(@"Devolviendo los filtros");
    return filtros;
}



#pragma mark - Methods
- (void) cargarFiltros{
    self.sectionTitles = [[self.filtros allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

#pragma mark -UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *sectionTitle = [sectionTitles objectAtIndex:section];
    NSArray *sectionFilters = [self.filtros objectForKey:sectionTitle];
    return [sectionFilters count];
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
    
    
    NSString *sectionTitle = [self.sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionFilters = [self.filtros objectForKey:sectionTitle];
    claveFiltro = [sectionFilters objectAtIndex:indexPath.row];
    
    //Fondo de las celdas gris oscuro.
    [cell setBackgroundColor:[UIColor darkGreyColorForCell]];

    cell.textLabel.text = claveFiltro;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//Para cambiar los colorcitos del header
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}




@end
