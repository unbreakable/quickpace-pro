//
//  MainViewController.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
}

@property (nonatomic, retain) IBOutlet UIButton               *shareButton;
@property (nonatomic, retain) IBOutlet UITextField            *paceDisplayText;
@property (nonatomic, retain) IBOutlet UITextField            *speedDisplay;
@property (nonatomic, retain) IBOutlet UITextField            *calorieDisplay;
@property (nonatomic, retain) IBOutlet UITextField            *distanceEntry;
@property (nonatomic, retain) IBOutlet UITextField            *hoursEntry;
@property (nonatomic, retain) IBOutlet UITextField            *minutesEntry;
@property (nonatomic, retain) IBOutlet UITextField            *secondsEntry;
@property (strong, nonatomic) IBOutlet UITextField            *inclineEntry;
@property (nonatomic, retain) IBOutlet UILabel                *enterYourSettingsText;
@property (nonatomic, retain) IBOutlet UIImageView            *enterYourSettingsCallout;
@property (strong, nonatomic)          NSManagedObjectContext *managedObjectContext;

- (IBAction) showInfo:(id)sender;
- (IBAction) calculateRun;
- (IBAction) clearAll;
- (IBAction) textFieldDidUpdate:(id)sender;
- (IBAction) openUIActivityView:(id)sender;
- (void)     resetDisplayLabels;
- (void)     displayWelcome;
- (void)     applicationDidBecomeActive: (NSNotification *)notification;
- (void)     saveRunWithPace: (NSString *)aPace 
                    andHours: (NSString *)theHrs
                  andMinutes: (NSString *)theMin
                  andSeconds: (NSString *)theSec
                 andDistance: (NSString *)aDistance
                    andSpeed: (NSString *)aSpeed
                 andCalories: (NSString *)theCalories
                  andIncline: (NSString *)theIncline;

@end
