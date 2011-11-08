//
//  MainViewController.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"
#import "RunStatsCalculator.h"
#import <CoreData/CoreData.h>
#import "SettingsManager.h"
#import "FlurryAnalytics.h"
#import "EffectsManager.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
    // Results display fields
    UITextField     *paceDisplayText;
    UITextField     *speedDisplay;
    UITextField     *calorieDisplay;
    
    // Data entry values
    UITextField     *hoursEntry;
    UITextField     *minutesEntry;
    UITextField     *secondsEntry;
    UITextField     *distanceEntry;
    
    // Welcome to app text
    UILabel         *enterYourSettingsText;
    UIImageView     *enterYourSettingsCallout;
}

@property (nonatomic, retain) IBOutlet UITextField            *paceDisplayText;
@property (nonatomic, retain) IBOutlet UITextField            *speedDisplay;
@property (nonatomic, retain) IBOutlet UITextField            *calorieDisplay;
@property (nonatomic, retain) IBOutlet UITextField            *distanceEntry;
@property (nonatomic, retain) IBOutlet UITextField            *hoursEntry;
@property (nonatomic, retain) IBOutlet UITextField            *minutesEntry;
@property (nonatomic, retain) IBOutlet UITextField            *secondsEntry;
@property (nonatomic, retain) IBOutlet UILabel                *enterYourSettingsText;
@property (nonatomic, retain) IBOutlet UIImageView            *enterYourSettingsCallout;
@property (strong, nonatomic)          NSManagedObjectContext *managedObjectContext;

-(IBAction) showInfo:(id)sender;
-(IBAction) calculateRun;
-(IBAction) clearAll;
-(IBAction) textFieldDidUpdate:(id)sender;
-(void)     resetDisplayLabels;
-(void)     displayWelcome;

@end
