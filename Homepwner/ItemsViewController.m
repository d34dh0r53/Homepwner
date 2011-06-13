//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Dave Wilde on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemsViewController.h"
#import "Possession.h"
#import "ItemDetailViewController.h"


@implementation ItemsViewController

- (id)init
{
    // Call the superclass's designated initializer
    [super initWithStyle:UITableViewStyleGrouped];
    
    // Create an array of 10 random possession objects
    possessions = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [possessions addObject:[Possession randomPossession]];
    }
    // Set the nav bar to have the pre-fab'ed Edit button when
    // ItemsViewController is on top of the stack
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    
    // Set the title of the nav bar to Homepwner when ItemsViewController
    // is on top of the stack
    [[self navigationItem] setTitle:@"Homepwner"];
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Do I need to create the instance of ItemDetailViewController?
    if (!detailViewController) {
        detailViewController = [[ItemDetailViewController alloc] init];
    }
    
    // Give detail view controller a pointer to the possession object in row
    [detailViewController setEditingPossession:[possessions objectAtIndex:[indexPath row]]];
    
    // Push it onto the top of the navigation controller's stack
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberOfRows = [possessions count];
    // If we are editing, we will have one more row than we have possessions
    if ([self isEditing])
        numberOfRows++;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"] autorelease];
    }
    
    // If the table view is filling a row with a possession in it, do as normal
    if ([indexPath row] < [possessions count]) {
        Possession *p = [possessions objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:[p description]];
    } else { // Otherwise, if we are editing we have one extra row...
        [[cell textLabel] setText:@"Add New Item..."];
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isEditing] && [indexPath row] == [possessions count]) {
        // The last row during editing will show an insert style button
        return UITableViewCellEditingStyleInsert;
    }
    // All other rows remain deletable
    return UITableViewCellEditingStyleDelete;
}

//- (UIView *)headerView
//{
//    if (headerView)
//        return headerView;
//    
//    // Create a UIButton object, simple rounded rect style
//    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    
//    // Set the title of this button to "Edit"
//    [editButton setTitle:@"Edit" forState:UIControlStateNormal];
//    
//    // How wide is the screen?
//    float w = [[UIScreen mainScreen] bounds].size.width;
//    
//    // Create a rectangle for the button
//    CGRect editButtonFrame = CGRectMake(8.0, 8.0, w - 16.0, 30.0);
//    [editButton setFrame:editButtonFrame];
//    
//    // When this button is tapped, send the message
//    // editingButtonPressed: to this instance of ItemsViewController
//    [editButton addTarget:self action:@selector(editingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    
//    // Create a rectangle for the headerView that will contian the button
//    CGRect headerViewFrame = CGRectMake(0, 0, w, 48);
//    headerView = [[UIView alloc] initWithFrame:headerViewFrame];
//    
//    // Add button to the headerView's view hierarchy
//    [headerView addSubview:editButton];
//    
//    return headerView;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [self headerView];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return [[self headerView] frame].size.height;
//}

//- (void)editingButtonPressed:(id)sender
//{
//    // If we are currently in editing mode...
//    if ([self isEditing]) {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        // Turn off editing mode
//        [self setEditing:NO animated:YES];
//    } else {
//        // Change text of button to inform user of state
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        // Enter editing mode
//        [self setEditing:YES animated:YES];
//    }
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // We remove the row being deleted from the possessions array
        [possessions removeObjectAtIndex:[indexPath row]];
        
        // We also remove that row from the table view with an adnimation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        NSLog(@"Inserting row...");
        // If the editing sytle of the row was insertion,
        // we add a new possession object and new row to the table view
        [possessions addObject:[Possession randomPossession]];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Only allow rows showing possessions to move
    if ([indexPath row] < [possessions count])
        return YES;
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([proposedDestinationIndexPath row] < [possessions count]) {
        // If we are moving to a row that currently is showing a possession,
        // the we return the row the user wanted to move to
        return proposedDestinationIndexPath;
    }
    // We get here is we are trying to move a row to under the "Add New Item..."
    // row, have the moving row go one row above it instead.
    NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[possessions count] - 1 inSection:0];
    return betterIndexPath;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    // Get pointer to object being moved
    Possession *p = [possessions objectAtIndex:[sourceIndexPath row]];
    
    // Retain p so that it is not deallocated with it is removed from the array
    [p retain];
        // Retain count of p is now 2
    
    // Remove p from our array, it is automatically sent release
    [possessions removeObjectAtIndex:[sourceIndexPath row]];
        // Retain count of p is now 1
    
    // Re-insert p into array at new location, it is automatically retained
    [possessions insertObject:possessions atIndex:[destinationIndexPath row]];
        // Retain count of p is now 2
    
    // Release p
    [p release];
        // Retain count of p is now 1
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Always call super implementation of this method, it needs to do work
    [super setEditing:editing animated:animated];
    
    // You need to insert/remove a new row in to table view
    if (editing) {
        // If entering edit mode, we add another row to our table view
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
        NSArray *paths = [NSArray arrayWithObject:indexPath];
        
        [[self tableView] insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        // If leaving edit mode, we remove last row from table view
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[possessions count] inSection:0];
        NSArray *paths = [NSArray arrayWithObject:indexPath];
        
        [[self tableView] deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}



/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
