//
//  QuickpaceTests.m
//  QuickpaceTests
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QuickpaceTests.h"

@implementation QuickpaceTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    app_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void) testAppDelegate
{
    STAssertNotNil(app_delegate, @"Cannot find the application delegate");
}

-(void) resetToDefaultSettings
{
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    [userSettings saveUnitsSetting:0];
    [userSettings saveSexSetting:0];
    [userSettings saveAgeSetting:@"30"];
    [userSettings saveHeightSetting:@"176.5"];
    [userSettings saveWeightSetting:@"70"];
}

#pragma mark - Run Calculator methods
-(void) testSpeed01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"6.00 mph";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testSpeed02
{ 
    [self resetToDefaultSettings];
    // Testing the pace seconds logic so it doesn't put something like "9:010 seconds" instead of "9:10"
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"0"];
    NSString *expected = @"0.0 mph";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testSpeed03
{
    [self resetToDefaultSettings];
    // Testing the interpolator if-thens by taking the speed up really high
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"4" andSeconds:@"40" andDistance:@"1"];
    NSString *expected = @"12.86 mph";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"10:00 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace02
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"26.2"];
    NSString *expected = @"9:10 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace03
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"0"];
    NSString *expected = @"0:00 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace04
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"0" andSeconds:@"0" andDistance:@"0"];
    NSString *expected = @"0.0 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace05
{ 
    // Same as test 02 but kilometer-style baby
    [self resetToDefaultSettings];
    // Testing the pace seconds logic so it doesn't put something like "9:010 seconds" instead of "9:10"
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    [userSettings saveUnitsSetting:1];
    
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"26.2"];
    NSString *expected = @"9:10 per km";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"124.3 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories02
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    [userSettings saveSexSetting:1];
    
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"23" andSeconds:@"0" andDistance:@"2"];
    NSString *expected = @"285.1 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories03
{
    [self resetToDefaultSettings];
    // Testing 1.33 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"45" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"108.0 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories04
{
    [self resetToDefaultSettings];
    // Testing 2.40 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"25" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"97.6 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories05
{
    [self resetToDefaultSettings];
    // Testing 3.16 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"19" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"93.1 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testMetricLabels01
{
    [self resetToDefaultSettings];
    
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    [userSettings saveUnitsSetting:1];
    [userSettings saveSexSetting:0];
    
    NSString *hours = @"0";
    NSString *minutes = @"60";
    NSString *seconds = @"0";
    NSString *distance = @"10";
    
    NSString *calResult = [runCalculator calculateCaloriesUsingHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    
    NSString *expectedCal = @"1103.3 kilocalories";
    STAssertEqualObjects (expectedCal, calResult, @"Did not compute calories correctly, expecting %@, got %@", expectedCal, calResult);
    
    NSString *paceResult = [runCalculator calculatePaceGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedPace = @"6:00 per km";
    STAssertEqualObjects (expectedPace, paceResult, @"Did not compute calories correctly, expecting %@, got %@", expectedPace, paceResult);
    
    NSString *speedResult = [runCalculator calculateSpeedGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedSpeed = @"10.00 kph";
    STAssertEqualObjects (expectedSpeed, speedResult, @"Did not compute calories correctly, expecting %@, got %@", expectedSpeed, speedResult);
}

-(void) testMetricLabels02
{
    // All values at zero
    [self resetToDefaultSettings];
    
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    [userSettings saveUnitsSetting:1];
    
    NSString *hours = @"0";
    NSString *minutes = @"0";
    NSString *seconds = @"0";
    NSString *distance = @"0";
    
    NSString *calResult = [runCalculator calculateCaloriesUsingHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    
    NSString *expectedCal = @"0.0 kilocalories";
    STAssertEqualObjects (expectedCal, calResult, @"Did not compute calories correctly, expecting %@, got %@", expectedCal, calResult);
    
    NSString *paceResult = [runCalculator calculatePaceGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedPace = @"0:00 per km";
    STAssertEqualObjects (expectedPace, paceResult, @"Did not compute calories correctly, expecting %@, got %@", expectedPace, paceResult);
    
    NSString *speedResult = [runCalculator calculateSpeedGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedSpeed = @"0.0 kph";
    STAssertEqualObjects (expectedSpeed, speedResult, @"Did not compute calories correctly, expecting %@, got %@", expectedSpeed, speedResult);
}

#pragma mark - Unit converter methods

-(void) testConversionToMetricHeight
{
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    NSDictionary *feetInches = [[NSDictionary alloc] initWithObjectsAndKeys:@"5", @"feet", @"9", @"inches", nil];
    NSString *cmResult = [converter convertToCentimetersGivenFeetInches:feetInches];
    NSString *cmExpected = @"175.3";
    
    STAssertEqualObjects (cmExpected, cmResult, @"Did not compute height in cm correctly, expecting %@, got %@", cmExpected, cmResult);
}

-(void) testConversionToImperialHeight
{
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    NSString *feetExpected = @"6";
    NSString *inchesExpected = @"2.0";
    
    NSDictionary *feetInchesResult = [NSDictionary dictionaryWithDictionary:[converter convertToFeetInchesGivenCentimeters:@"188.0"]];
    NSString *feetResult = [NSString stringWithString:[feetInchesResult objectForKey:@"feet"]];
    NSString *inchesResult = [NSString stringWithString:[feetInchesResult objectForKey:@"inches"]];
    
    STAssertEqualObjects (feetExpected, feetResult, @"Did not compute feet correctly, expecting %@, got %@", feetExpected, feetResult);
    
    STAssertEqualObjects (inchesExpected, inchesResult, @"Did not compute inches correctly, expecting %@, got %@", inchesExpected, inchesResult);
}

-(void) testConversionToPounds
{
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    NSString *poundsExpected = @"100.1";
    NSString *poundsResult = [converter convertToPoundsGivenKgs:@"45.4"];
    
    STAssertEqualObjects(poundsExpected, poundsResult, @"Crap! Expected %@ pounds but got %@", poundsExpected, poundsResult);
}

-(void) testConversionToKilograms
{
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    NSString *kgsExpected = @"99.8";
    NSString *kgsResult = [converter convertToKilogramsGivenLbs:@"220"];
    
    STAssertEqualObjects(kgsExpected, kgsResult, @"Crap! Expected %@ pounds but got %@", kgsExpected, kgsResult);
}


#pragma mark - Settings manager methods

-(void) testUsageDefaultGetter
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    NSString *usageSettingResult =   [NSString stringWithString:[userSettings getUsageDefault]];
    NSString *usageSettingExpected = @"Yes";
    
    STAssertEqualObjects(usageSettingExpected, usageSettingResult, @"Crap! Expected %@ but got %@", usageSettingExpected, usageSettingResult);
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

@end
