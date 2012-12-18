//
//  HistoryViewController.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "SettingsManager.h"
#import "Run.h"
#import "RunDetailViewController.h"

@implementation HistoryViewController

@synthesize historyArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


// Using a standard Apple history icon and label in the app delegate instead
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Now handled in the AppDelegate
        // self.tabBarItem = [self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemHistory tag:2];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    /*
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;

    // NSString *fieldName = [NSString stringWithFormat:@"line%d", i];
    // UITextField *theField = [self valueForKey:fieldName];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    // NSPredicate *pred = [NSPredicate predicateWithFormat:@"(lineNum = %d)", i];
    // [request setPredicate:pred];
    
    // NSManagedObjectContext *theLine = nil;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if (objects == nil) 
    {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    
     if ([objects count] > 0)
     theLine = [objects objectAtIndex:0];
     else
     theLine = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:context];

    // [theLine setValue:[NSNumber numberWithInt:i] forKey:@"lineNum"];
    // [theLine setValue:theField.text forKey:@"lineText"];
    
    //[context save:&error];
    */
}

- (void)loadHistory
{
    // Core data code
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run"
                                                         inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Sort results
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *runObjects = [context executeFetchRequest:request error:&error];
    if (runObjects == nil)
    {
        NSLog(@"There was an error!");
        // Do whatever error handling is appropriate
    }
    
    historyArray = [[NSMutableArray alloc] initWithArray:runObjects];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // This gets the view registered to know when the app goes inactive so it can save the in-memory changes in the "context" to the database
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:) 
                                                 name:UIApplicationWillResignActiveNotification
                                               object:app];
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadHistory];
    NSLog(@"View will appear was called");
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [historyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    }
    
    // A date formatter for the run date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
    // Get the event corresponding to the current index path and configure the table view cell.
	Run *run = (Run *)[historyArray objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ at %@", [run distance], [run pace]];
	
	NSString *string = [NSString stringWithFormat:@"On %@",[dateFormatter stringFromDate:[run date]]];
    cell.detailTextLabel.text = string;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        // Delete the managed object at the given index path.
        NSManagedObject *runToDelete = [historyArray objectAtIndex:indexPath.row];
        [context deleteObject:runToDelete];
        
        // Update the array and table view.
        [historyArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Commit the change.
        NSError *error = nil;
        if (![context save:&error]) 
        {
            // Handle the error.
        }
    }
}


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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create and push a detail view controller.
    
    RunDetailViewController *detailViewController = [[RunDetailViewController alloc] initWithNibName:@"RunDetailViewController" bundle:nil];
    
    Run *selectedRun = (Run *)[historyArray objectAtIndex:indexPath.row];
    // Pass the selected book to the new view controller.
    detailViewController.run = selectedRun;
	[self.navigationController pushViewController:detailViewController animated:YES];
}

@end
