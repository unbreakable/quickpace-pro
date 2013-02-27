//
//  MainViewController.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "RunStatsCalculator.h"
#import "SettingsManager.h"
#import "Flurry.h"
#import "EffectsManager.h"
#import "Run.h"

@implementation MainViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize shareButton, distanceEntry, hoursEntry, minutesEntry, secondsEntry, inclineEntry, paceDisplayText, speedDisplay, calorieDisplay, enterYourSettingsText, enterYourSettingsCallout;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calculate", @"Calculate");
        self.tabBarItem.image = [UIImage imageNamed:@"Calculator-icon"];
    }
    return self;
}

- (void)applicationDidBecomeActive: (NSNotification *)notification
{
    // This pattern of registering for notification from the didBecomeActive and using that to trigger the display
    // welcome bubble and text comes from Beginning iPhone 4 in their Data Persistence chapter (archiver example)
    [self displayWelcome];
}

#pragma mark - Action methods

- (void)resetDisplayLabels
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] )
    {
        paceDisplayText.text = @"for each km";
        speedDisplay.text = @"in km per hour";
        distanceEntry.placeholder = @"in km";
    } else
    {
        paceDisplayText.text = @"for each mile";
        speedDisplay.text = @"in miles per hour";
        distanceEntry.placeholder = @"in miles";
    }
    calorieDisplay.text = @"burned";
}

- (IBAction)clearAll
{
    hoursEntry.text = @"";
    minutesEntry.text = @"";    
    secondsEntry.text = @"";
    distanceEntry.text = @"";
    inclineEntry.text = @"";
    [self resetDisplayLabels];
    [hoursEntry becomeFirstResponder];
    
    [Flurry logEvent:@"Clear button tapped"];
}

- (IBAction)calculateRun
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
                                                       andDistance:distanceEntry.text
                                                        andIncline:inclineEntry.text];
    
    // Save run to database
    [self saveRunWithPace:paceDisplayText.text andHours:hoursEntry.text andMinutes:minutesEntry.text andSeconds:secondsEntry.text andDistance:distanceEntry.text andSpeed:speedDisplay.text andCalories:calorieDisplay.text andIncline:inclineEntry.text];
    
    // These are just here to dismiss the keyboard
    [distanceEntry becomeFirstResponder];
    [distanceEntry resignFirstResponder];
    
    // Usage info (flurry)
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    float totalRunTimeInMinutes = [theRunStats totalRunInMinutesGivenHours:hoursEntry.text andMinutes:minutesEntry.text andSeconds:secondsEntry.text];
    NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithFloat:totalRunTimeInMinutes], @"runInMinutes",
                               paceDisplayText.text, @"pace", 
                               speedDisplay.text, @"speed", 
                               calorieDisplay.text, @"calories",
                               inclineEntry.text, @"incline",
                               [userSettings getAgeDefault], @"age",
                               [userSettings getSexDefault], @"sex",
                               [userSettings getHeightDefault], @"height", 
                               [userSettings getWeightDefault], @"weight",  
                               [userSettings getUnitsDefault], @"units", 
                               nil];
    [Flurry logEvent:@"Calculate button tapped" withParameters:flurryDic];
}

- (void)saveRunWithPace: (NSString *)aPace 
               andHours: (NSString *)theHrs
             andMinutes: (NSString *)theMin
             andSeconds: (NSString *)theSec
            andDistance: (NSString *)aDistance
               andSpeed: (NSString *)aSpeed
            andCalories: (NSString *)theCalories
             andIncline: (NSString *)theIncline;
{
    NSDate *aDate = [NSDate date];
    NSString *distanceUnits;
    NSString *fullDistance;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Run"
                                                         inManagedObjectContext:context];
    [request setEntity:entityDescription];
    
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] )
        distanceUnits = @"km";
    else
        distanceUnits = @"mi";
    
    fullDistance = [NSString stringWithFormat:@"%@ %@", aDistance, distanceUnits];
    
    NSManagedObject *theRun = [NSEntityDescription insertNewObjectForEntityForName:@"Run" 
                                                            inManagedObjectContext:context];
    [theRun setValue:aDate        forKey:@"date"];
    [theRun setValue:aPace        forKey:@"pace"];
    [theRun setValue:fullDistance forKey:@"distance"];
    [theRun setValue:theHrs       forKey:@"durationHrs"];
    [theRun setValue:theMin       forKey:@"durationMin"];
    [theRun setValue:theSec       forKey:@"durationSec"];
    [theRun setValue:aSpeed       forKey:@"speed"];
    [theRun setValue:theCalories  forKey:@"calories"];
    [theRun setValue:theIncline   forKey:@"incline"];
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        
    }
}

- (void)displayWelcome
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

-(IBAction)openUIActivityView:(id)sender {
    NSString *runTime, *distanceUnits, *inclinePhrase, *hoursBlurb, *minutesBlurb, *secondsBlurb;
    
    // Get the units to append to the "I just ran X [miles/km]" phrase
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] ) {
        distanceUnits = @"km";
    } else {
        if ( [distanceEntry.text floatValue] == 1 ) {
            distanceUnits = @"mile";
        } else {
            distanceUnits = @"miles";
        }
    }
    
    // If incline is empty just end the sentence. Otherwise drop in the incline phrase.
    if ( [inclineEntry.text isEqualToString: @""] ) {
        inclinePhrase = [NSString stringWithFormat: @""];
    } else {
        inclinePhrase = [NSString stringWithFormat: @" at a %@%% incline", inclineEntry.text];
    }
    
    if ( [hoursEntry.text isEqualToString: @""] || [hoursEntry.text isEqualToString: @"00"] ) {
        hoursBlurb = @"";
    } else {
        hoursBlurb = [NSString stringWithFormat: @"%@:", hoursEntry.text];
    }
    
    if ( [minutesEntry.text isEqualToString: @""] || [minutesEntry.text isEqualToString: @"00"] ) {
        minutesBlurb = @"00";
    } else if ( [minutesEntry.text floatValue] > 0 && [minutesEntry.text floatValue] < 10 ) {
        minutesBlurb = [NSString stringWithFormat: @"0%@", minutesEntry.text];
    } else {
        minutesBlurb = minutesEntry.text;
    }
    
    if ( [secondsEntry.text isEqualToString: @""] ) {
        secondsBlurb = @"";
    } else if ( [secondsEntry.text floatValue] > 0 && [secondsEntry.text floatValue] < 10 ) {
        secondsBlurb = [NSString stringWithFormat: @":0%@", secondsEntry.text];
    } else if ( [secondsEntry.text isEqualToString: @"00"] ) {
        secondsBlurb = @":00";
    } else {
        secondsBlurb = [NSString stringWithFormat: @":%@", secondsEntry.text];
    }
    
    // If only minutes are specified, make it more readable by saying "I ran x miles in y minutes..."
    if ( ([hoursEntry.text isEqualToString: @""] || [hoursEntry.text isEqualToString: @"00"]) && ([secondsEntry.text isEqualToString: @""] || [secondsEntry.text isEqualToString: @"00"]) ){
        if ( [minutesEntry.text floatValue] == 1 ) {
            minutesBlurb = [NSString stringWithFormat: @"%@ minute", minutesEntry.text];
        } else {
            minutesBlurb = [NSString stringWithFormat: @"%@ minutes", minutesEntry.text];
        }
        hoursBlurb = @"";
        secondsBlurb = @"";
    }
    
    // If only hours are specified, make it more readable by saying "I ran x miles in y hours..."
    if ( ([minutesEntry.text isEqualToString: @""] || [minutesEntry.text isEqualToString: @"00"]) && ([secondsEntry.text isEqualToString: @""] || [secondsEntry.text isEqualToString: @"00"]) ) {
        if ( [hoursEntry.text floatValue] == 1 ) {
            hoursBlurb = [NSString stringWithFormat: @"%@ hour", hoursEntry.text];
        } else {
            hoursBlurb = [NSString stringWithFormat: @"%@ hours", hoursEntry.text];
        }
        minutesBlurb = @"";
        secondsBlurb = @"";
    }
    
    runTime = [NSString stringWithFormat: @"%@%@%@", hoursBlurb, minutesBlurb, secondsBlurb];
        
    NSString *textToShare = [NSString stringWithFormat: @"I ran %@ %@ in %@%@. Quickpace Pro calculated my pace at %@ and I burned %@.", distanceEntry.text, distanceUnits, runTime, inclinePhrase, paceDisplayText.text, calorieDisplay.text];
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    // This is an array of excluded activities that should not appear on the UIActivityView
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [Flurry logEvent:@"Share button tapped"];
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // This registers to be notified when the app became active so the welcome message can be displayed
    // Basic idea came from Beginning iPhone 4 book, Data Persistence app (second version using archiving)
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(applicationDidBecomeActive:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:app];
    
    if (![UIActivityViewController class]) {
        // hides the share button if feature unavailable
        self.shareButton.hidden = YES;
    }
    
    [self resetDisplayLabels];
    
    [self displayWelcome]; // Called here and in AppDidBecomeActive. Necessary here so welcome fades out on initial load.
    
    [hoursEntry becomeFirstResponder];    
    
    [super viewDidLoad];
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
    
    [Flurry logEvent:@"Keyboard 'Return' key used in Main view"];
    
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

- (IBAction)textFieldDidUpdate:(id)sender
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
    
    [Flurry logEvent:@"User visited settings view"];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentModalViewController:controller animated:YES];
}

@end
