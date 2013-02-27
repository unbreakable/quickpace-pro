//
//  SettingsViewController.h
//  QuickpacePro
//
//  Created by JFK on 2/26/13.
//
//

#import <UIKit/UIKit.h>
#import "UnitConverter.h"
#import "SettingsManager.h"
#import "Flurry.h"
#import "EffectsManager.h"

@interface SettingsViewController : UIViewController
{
    // UI elements
    UISegmentedControl *unitsPicker;
    UISegmentedControl *sexPicker;
    UITextField        *ageEntry;
    UITextField        *metricHeightEntry;
    UITextField        *metricWeightEntry;
    UITextField        *imperialWeightEntry;
    UITextField        *feetEntry;
    UITextField        *inchEntry;
    UILabel            *feetInchMarkers;
    UIButton           *keyboardDismisser;
    
    // Keyboard scrolling variables
    CGFloat			    scrollAmount;
    BOOL			    moveViewUp;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *unitsPicker;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sexPicker;
@property (nonatomic, retain) IBOutlet UITextField        *ageEntry;
@property (nonatomic, retain) IBOutlet UITextField        *metricHeightEntry;
@property (nonatomic, retain) IBOutlet UITextField        *metricWeightEntry;
@property (nonatomic, retain) IBOutlet UITextField        *imperialWeightEntry;
@property (nonatomic, retain) IBOutlet UITextField        *feetEntry;
@property (nonatomic, retain) IBOutlet UITextField        *inchEntry;
@property (nonatomic, retain) IBOutlet UILabel            *feetInchMarkers;

// Calling and persisting defaults
-(IBAction)   saveUnitsSetting;
-(IBAction)   saveAgeSetting;
-(IBAction)   saveSexSetting;
-(IBAction)   saveHeightSetting;
-(IBAction)   saveWeightSetting;
-(void)       getAllSettingsInFlip;

// Keyboard scrolling
- (void)keyboardWillShow:(NSNotification *)notif;
- (void)scrollTheView:(BOOL)movedUp;

@end
