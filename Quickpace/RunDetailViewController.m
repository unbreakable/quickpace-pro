//
//  RunDetailViewController.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RunDetailViewController.h"
#import "Run.h"
#import "Flurry.h"

@implementation RunDetailViewController

@synthesize run;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the title, title bar, and table view.
	self.title = @"Run Details";
    //self.title.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//self.tableView.allowsSelectionDuringEditing = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Treadmill-worn-640-2.png"]];
    
    /*
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"quickpace blue background.png"]];
    [self.view addSubview:backgroundView];
    */
    
    //This method produces odd artifacts in the background image:ATableViewController *yourTableViewController = [[ATableViewController alloc] initWithStyle:UITableViewStyleGrouped];yourTableViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TableViewBackground.png"]];[window addSubview:yourTableViewController.view];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.accessibilityLabel = @"HistoryDetails"; // accessibility label for ui automation testing
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    [Flurry logEvent:@"User visited history summary view"];
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

/*
// Uncomment this to create an Edit button on the detail view screen
- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
    [super setEditing:editing animated:animated];
	
	// Hide the back button when editing starts, and show it again when editing finishes.
    [self.navigationItem setHidesBackButton:editing animated:animated];
    [self.tableView reloadData];
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // A date formatter for the run date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
    
	NSString *dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:[run date]]];
	
    // Configure the cells...
	switch (indexPath.row) {
        case 0: 
			cell.textLabel.text = @"Date";
            cell.accessibilityLabel = @"Date";
			cell.detailTextLabel.text = dateString;
			break;
        case 1: 
			cell.textLabel.text = @"Distance";
            cell.accessibilityLabel = @"Distance";
			cell.detailTextLabel.text = run.distance;
            break;
        case 2:
        {
            // Actually, just check to see if string is == @"" and if so, make it @"00"
			cell.textLabel.text = @"Time";
            cell.accessibilityLabel = @"Time";
            NSString *runHrs, *runMin, *runSec;
            
            if ([run.durationHrs isEqualToString:@""]) 
                runHrs = [NSString stringWithFormat:@"00"];
            else
                runHrs = run.durationHrs;
    
            if ([run.durationMin isEqualToString:@""]) 
                runMin = [NSString stringWithFormat:@"00"];
            else
                runMin = run.durationMin;
            
            if ([run.durationSec isEqualToString:@""]) 
                runSec = [NSString stringWithFormat:@"00"];
            else
                runSec = run.durationSec;
            
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@:%@:%@", runHrs, runMin, runSec];
        }
			break;
        case 3:
			cell.textLabel.text = @"Pace";
            cell.accessibilityLabel = @"Pace";
            cell.detailTextLabel.text = run.pace;
			break;
        case 4:
			cell.textLabel.text = @"Speed";
            cell.accessibilityLabel = @"Speed";
			cell.detailTextLabel.text = run.speed;
			break;
        case 5:
			cell.textLabel.text = @"Calories";
            cell.accessibilityLabel = @"Calories";
			cell.detailTextLabel.text = run.calories;
			break;
        case 6:
            // Check to see if string is == @"" or NULL (from the older non-incline version) and if so, make it @"0.0%", otherwise show the value with the % sign
			cell.textLabel.text = @"Incline";
            cell.accessibilityLabel = @"Incline";
            NSString *runIncline;
            if ([run.incline isEqualToString:@""] || run.incline == NULL)
                runIncline = @"0.0";
            else
                runIncline = run.incline;
			cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%%", runIncline];
			break;
    }
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
