//
//  MainViewController.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize distanceEntry, hoursEntry, minutesEntry, secondsEntry, paceDisplayText, speedDisplay, calorieDisplay, enterYourSettingsText, enterYourSettingsCallout;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Units methods

-(void) resetDisplayLabels
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] )
    {
        paceDisplayText.text = @"for each kilometer";
        speedDisplay.text = @"in kilometers per hour";
        distanceEntry.placeholder = @"in kilometers";
    } else
    {
        paceDisplayText.text = @"for each mile";
        speedDisplay.text = @"in miles per hour";
        distanceEntry.placeholder = @"in miles";
    }
    calorieDisplay.text = @"burned";
}

-(IBAction) clearAll
{
    hoursEntry.text = @"";
    minutesEntry.text = @"";    
    secondsEntry.text = @"";
    distanceEntry.text = @"";
    [self resetDisplayLabels];
    [minutesEntry becomeFirstResponder];
    
    [FlurryAnalytics logEvent:@"Clear button tapped"];
}

-(IBAction) calculateRun
{
    RunStatsCalculator *theRunStats = [[RunStatsCalculator alloc] init];
    
    paceDisplayText.text = [theRunStats calculatePaceGivenHours:hoursEntry.text 
                                                     andMinutes:minutesEntry.text
                                                     andSeconds:secondsEntry.text
                                                    andDistance:distanceEntry.text];
    
    speedDisplay.text = [theRunStats calculateSpeedGivenHours:hoursEntry.text 
                                                   andMinutes:minutesEntry.text
                                                   andSeconds:secondsEntry.text
                                                  andDistance:distanceEntry.text];
    
    calorieDisplay.text = [theRunStats calculateCaloriesUsingHours:hoursEntry.text 
                                                        andMinutes:minutesEntry.text
                                                        andSeconds:secondsEntry.text
                                                       andDistance:distanceEntry.text];    
    // These are just here to dismiss the keyboard
    [distanceEntry becomeFirstResponder];
    [distanceEntry resignFirstResponder];
    
    // Usage info
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    NSString *userRunTime = [NSString stringWithFormat:@"Run time %@:%@:%@",hoursEntry.text, minutesEntry.text, secondsEntry.text];
    NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               userRunTime, @"runTime", 
                               paceDisplayText.text, @"pace", 
                               speedDisplay.text, @"speed", 
                               calorieDisplay.text, @"calories",
                               [userSettings getAgeDefault], @"age",
                               [userSettings getSexDefault], @"sex",
                               [userSettings getHeightDefault], @"height", 
                               [userSettings getWeightDefault], @"weight",  
                               [userSettings getUnitsDefault], @"units", 
                               nil];
    [FlurryAnalytics logEvent:@"Calculate button tapped" withParameters:flurryDic];
}

-(void) displayWelcome
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ( [defaults objectForKey:@"age"] && [defaults objectForKey:@"weight"] && [defaults objectForKey:@"height"] )
    {
        enterYourSettingsCallout.alpha = 0;
        enterYourSettingsText.alpha = 0;
    } else
    {
        EffectsManager *uiEffects = [[EffectsManager alloc] init];
        [uiEffects fadeIn:  enterYourSettingsText    withDuration: 0.5 andWait: 0.3];
        [uiEffects fadeIn:  enterYourSettingsCallout withDuration: 0.5 andWait: 0.3];
        
        [uiEffects fadeOut: enterYourSettingsText    withDuration: 0.8 andWait: 3.0];
        [uiEffects fadeOut: enterYourSettingsCallout withDuration: 0.8 andWait: 3.0];
    } 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self resetDisplayLabels];
    
    [minutesEntry becomeFirstResponder];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
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
    return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || 
            (interfaceOrientation == UIInterfaceOrientationPortrait));
}

#pragma mark - UITextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    if (theTextField == hoursEntry) 
    {
        [minutesEntry becomeFirstResponder];
    }
    else if (theTextField == minutesEntry) 
    {
        [secondsEntry becomeFirstResponder];
    }
    else if (theTextField == secondsEntry) 
    {
        [distanceEntry becomeFirstResponder];
    }
    else if (theTextField == distanceEntry) 
    {
        [theTextField resignFirstResponder];
        [self calculateRun];
        return YES;
    }
    
    [FlurryAnalytics logEvent:@"Keyboard 'Return' key used in Main view"];
    
    return NO;
}

-(void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event 
{
    for (UIView* view in self.view.subviews) 
    {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

-(IBAction) textFieldDidUpdate:(id)sender
{
	UITextField *textField = (UITextField *)sender;
	int characterCount = [textField.text length];
	if (characterCount == 2)
    {
		[self textFieldShouldReturn:textField];
	}
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
    
    // Pulls any changes in the units and sets proper mile or kilometer labels
    [self resetDisplayLabels];
    
    [FlurryAnalytics logEvent:@"User visited settings view"];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

@end
