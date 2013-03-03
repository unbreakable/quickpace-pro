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

#pragma mark - Share Text methods
-(void) testTimeHoursOnly
{
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"2" andMinutes:@"" andSeconds:@"" andDistance:@"2" andIncline:@""];
    
    NSString *expected = @"I ran 2 miles in 2 hours. Quickpace Pro calculated my pace at 60:00 per mile and I burned 254.1 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeMinutesOnly {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"" andMinutes:@"20" andSeconds:@"" andDistance:@"2" andIncline:@"10.5"];
    
    NSString *expected = @"I ran 2 miles in 20 minutes at a 10.5% incline. Quickpace Pro calculated my pace at 10:00 per mile and I burned 358.7 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeHoursMinutes {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"1" andMinutes:@"10" andSeconds:@"" andDistance:@"1.25" andIncline:@""];
    
    NSString *expected = @"I ran 1.25 miles in 1:10. Quickpace Pro calculated my pace at 56:00 per mile and I burned 152.5 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeHoursSeconds {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"1" andMinutes:@"" andSeconds:@"30" andDistance:@"6" andIncline:@""];
    
    NSString *expected = @"I ran 6 miles in 1:00:30. Quickpace Pro calculated my pace at 10:05 per mile and I burned 746.2 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeMinutesSeconds {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"" andMinutes:@"35" andSeconds:@"45" andDistance:@"4" andIncline:@""];
    
    NSString *expected = @"I ran 4 miles in 35:45. Quickpace Pro calculated my pace at 8:56 per mile and I burned 483.1 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeZeroHours {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"00" andMinutes:@"18" andSeconds:@"20" andDistance:@"3" andIncline:@"0"];
    
    NSString *expected = @"I ran 3 miles in 18:20 at a 0% incline. Quickpace Pro calculated my pace at 6:07 per mile and I burned 329.9 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeZeroMinutes {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"2" andMinutes:@"00" andSeconds:@"38" andDistance:@"10" andIncline:@"1"];
    
    NSString *expected = @"I ran 10 miles in 2:00:38 at a 1% incline. Quickpace Pro calculated my pace at 12:04 per mile and I burned 1312.1 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeZeroSeconds {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"3" andMinutes:@"30" andSeconds:@"00" andDistance:@"26.2" andIncline:@""];
    
    NSString *expected = @"I ran 26.2 miles in 3:30:00. Quickpace Pro calculated my pace at 8:01 per mile and I burned 3032.9 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeSingleDigitMinutes {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"1" andMinutes:@"1" andSeconds:@"" andDistance:@"5" andIncline:@""];
    
    NSString *expected = @"I ran 5 miles in 1:01. Quickpace Pro calculated my pace at 12:12 per mile and I burned 626.2 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeSingleDigitSeconds {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"" andMinutes:@"10" andSeconds:@"1" andDistance:@"1" andIncline:@""];
    
    NSString *expected = @"I ran 1 mile in 10:01. Quickpace Pro calculated my pace at 10:01 per mile and I burned 124.3 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testTimeOneMinute {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    
    result = [theShareText createShareTextUsingHours:@"" andMinutes:@"1" andSeconds:@"" andDistance:@"0.25" andIncline:@""];
    
    NSString *expected = @"I ran 0.25 miles in 1 minute. Quickpace Pro calculated my pace at 4:00 per mile and I burned 33.2 calories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testMetricShare {
    ShareText *theShareText = [[ShareText alloc] init];
    NSString *result;
    
    [self resetToDefaultSettings];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    [userSettings saveUnitsSetting:1];
    
    result = [theShareText createShareTextUsingHours:@"" andMinutes:@"30" andSeconds:@"" andDistance:@"5" andIncline:@""];
    NSString *expected = @"I ran 5 km in 30 minutes. Quickpace Pro calculated my pace at 6:00 per km and I burned 382.6 kilocalories.";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

#pragma mark - Run Calculator methods
-(void) testSpeed01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"6.00 mph";
    STAssertEqualObjects (expected, result, @"Did not compute speed correctly, expecting %@, got %@", expected, result);
}

-(void) testSpeed02
{
    // Testing the pace seconds logic so it doesn't put something like "9:010 seconds" instead of "9:10"
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"0"];
    NSString *expected = @"0.0 mph";
    STAssertEqualObjects (expected, result, @"Did not compute speed correctly, expecting %@, got %@", expected, result);
}

-(void) testSpeed03
{
    // Testing the interpolator if-thens by taking the speed up really high
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateSpeedGivenHours:@"0" andMinutes:@"4" andSeconds:@"40" andDistance:@"1"];
    NSString *expected = @"12.86 mph";
    STAssertEqualObjects (expected, result, @"Did not compute speed correctly, expecting %@, got %@", expected, result);
}

-(void) testPace01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1"];
    NSString *expected = @"10:00 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute pace correctly, expecting %@, got %@", expected, result);
}

-(void) testPace02
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"26.2"];
    NSString *expected = @"9:10 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute pace correctly, expecting %@, got %@", expected, result);
}

-(void) testPace03
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"0"];
    NSString *expected = @"0:00 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute pace correctly, expecting %@, got %@", expected, result);
}

-(void) testPace04
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"0" andSeconds:@"0" andDistance:@"0" andIncline:@"0"];
    NSString *expected = @"0.0 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testPace05
{ 
    // Same as test 02 but kilometer-style baby
    // Testing the pace seconds logic so it doesn't put something like "9:010 seconds" instead of "9:10"
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    [userSettings saveUnitsSetting:1];
    
    NSString *result = [runCalculator calculatePaceGivenHours:@"4" andMinutes:@"0" andSeconds:@"0" andDistance:@"26.2"];
    NSString *expected = @"9:10 per km";
    STAssertEqualObjects (expected, result, @"Did not compute pace correctly, expecting %@, got %@", expected, result);
}

-(void) testPace06RoundingSeconds
{
    // Testing that pace does not round incorrectly to X minutes and 60 seconds, but rather X+1 minutes and 0 seconds.
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    
    NSString *result = [runCalculator calculatePaceGivenHours:@"0" andMinutes:@"17" andSeconds:@"59" andDistance:@"2"];
    NSString *expected = @"9:00 per mile";
    STAssertEqualObjects (expected, result, @"Did not compute pace correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories01
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"10" andSeconds:@"0" andDistance:@"1" andIncline:@"0"];
    NSString *expected = @"124.3 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories02
{
    [self resetToDefaultSettings];
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    SettingsManager *userSettings = [[SettingsManager alloc] init];
    
    [userSettings saveSexSetting:1];
    
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"23" andSeconds:@"0" andDistance:@"2" andIncline:@"0"];
    NSString *expected = @"285.1 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories03
{
    [self resetToDefaultSettings];
    // Testing 1.33 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"45" andSeconds:@"0" andDistance:@"1" andIncline:@"0"];
    NSString *expected = @"108.0 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories04
{
    [self resetToDefaultSettings];
    // Testing 2.40 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"25" andSeconds:@"0" andDistance:@"1" andIncline:@"0"];
    NSString *expected = @"97.6 calories";
    STAssertEqualObjects (expected, result, @"Did not compute calories correctly, expecting %@, got %@", expected, result);
}

-(void) testCalories05
{
    [self resetToDefaultSettings];
    // Testing 3.16 mph
    RunStatsCalculator *runCalculator = [[RunStatsCalculator alloc] init];
    NSString *result = [runCalculator calculateCaloriesUsingHours:@"0" andMinutes:@"19" andSeconds:@"0" andDistance:@"1" andIncline:@"0"];
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
    
    NSString *calResult = [runCalculator calculateCaloriesUsingHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance andIncline:@"0"];
    
    NSString *expectedCal = @"765.2 kilocalories";
    STAssertEqualObjects (expectedCal, calResult, @"Did not compute calories correctly, expecting %@, got %@", expectedCal, calResult);
    
    NSString *paceResult = [runCalculator calculatePaceGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedPace = @"6:00 per km";
    STAssertEqualObjects (expectedPace, paceResult, @"Did not compute pace correctly, expecting %@, got %@", expectedPace, paceResult);
    
    NSString *speedResult = [runCalculator calculateSpeedGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedSpeed = @"10.00 kph";
    STAssertEqualObjects (expectedSpeed, speedResult, @"Did not compute speed correctly, expecting %@, got %@", expectedSpeed, speedResult);
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
    
    NSString *calResult = [runCalculator calculateCaloriesUsingHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance andIncline:@"0"];
    
    NSString *expectedCal = @"0.0 kilocalories";
    STAssertEqualObjects (expectedCal, calResult, @"Did not compute calories correctly, expecting %@, got %@", expectedCal, calResult);
    
    NSString *paceResult = [runCalculator calculatePaceGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedPace = @"0:00 per km";
    STAssertEqualObjects (expectedPace, paceResult, @"Did not compute pace correctly, expecting %@, got %@", expectedPace, paceResult);
    
    NSString *speedResult = [runCalculator calculateSpeedGivenHours:hours andMinutes:minutes andSeconds:seconds andDistance:distance];
    NSString *expectedSpeed = @"0.0 kph";
    STAssertEqualObjects (expectedSpeed, speedResult, @"Did not compute speed correctly, expecting %@, got %@", expectedSpeed, speedResult);
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
