//
//  QuickpaceTests.h
//  QuickpaceTests
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "ShareText.h"
#import "RunStatsCalculator.h"
#import "UnitConverter.h"
#import "EffectsManager.h"

@interface QuickpaceTests : SenTestCase
{
    @private
    AppDelegate            *app_delegate;
 
    // Not sure if I need these yet
    MainViewController     *main_view_controller;
    SettingsViewController *settings_view_controller;
    RunStatsCalculator     *run_calculator;
    UnitConverter          *unit_converter;
    UIView                 *pace_view;
}

-(void) setUp; 

-(void) resetToDefaultSettings;

// Run Calculator class tests
-(void) testSpeed01;
-(void) testSpeed02;
-(void) testSpeed03;
-(void) testPace01;
-(void) testPace02;
-(void) testPace03;
-(void) testPace04;
-(void) testPace05;
-(void) testPace06RoundingSeconds;
-(void) testCalories01;
-(void) testCalories02;
-(void) testCalories03;
-(void) testCalories04;
-(void) testCalories05;
-(void) testMetricLabels01;

// ShareText class tests
-(void) testTimeHoursOnly;
-(void) testTimeMinutesOnly;
-(void) testTimeHoursMinutes;
-(void) testTimeHoursSeconds;
-(void) testTimeMinutesSeconds;
-(void) testTimeZeroHours;
-(void) testTimeZeroMinutes;
-(void) testTimeZeroSeconds;
-(void) testTimeSingleDigitMinutes;
-(void) testTimeSingleDigitSeconds;
-(void) testTimeOneMinute;
-(void) testMetricShare;

// MainView class tests

// SettingsView class tests

// Settings Manager class tests
-(void) testUsageDefaultGetter;

// Unit Converter class tests
-(void) testConversionToMetricHeight;
-(void) testConversionToImperialHeight;
-(void) testConversionToPounds;
-(void) testConversionToKilograms;

@end
