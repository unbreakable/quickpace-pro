//
//  SettingsManager.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

-(id) init
{
    return [self initWithSettings];
}

-(id) initWithSettings
{
    self = [super init];
    
    if (self)
    {
        settings = [NSDictionary dictionaryWithDictionary:[self getAllSettings]];
    }
    
    return self;
}

#pragma mark - Get settings

-(NSDictionary *) getAllSettings
{
    NSString *aSex     = [NSString stringWithString:[self getSexDefault]];
    NSString *anAge    = [NSString stringWithString:[self getAgeDefault]];
    NSString *aHeight  = [NSString stringWithString:[self getHeightDefault]];
    NSString *aWeight  = [NSString stringWithString:[self getWeightDefault]];
    NSString *theUnits = [NSString stringWithString:[self getUnitsDefault]];
    
    NSDictionary *allSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                 aSex, @"sex", 
                                 anAge, @"age",
                                 aHeight, @"height",
                                 aWeight, @"weight",
                                 theUnits, @"units",
                                 nil];
    
    return allSettings;
}

-(NSString *) getSexDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *sexString;
    
    if ([defaults objectForKey:@"gender"]) 
        sexString = [defaults objectForKey:@"gender"];
    else
        sexString = [NSString stringWithString:@"male"];
    
    return sexString;
}

-(NSString *) getAgeDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *ageString;
    
    if ([defaults objectForKey:@"age"])
        ageString = [defaults objectForKey:@"age"];
    else
        ageString = [NSString stringWithString:@"30"];
    
    return ageString;
}

-(NSString *) getHeightDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *heightString;
    
    if ([defaults objectForKey:@"height"])
        heightString = [defaults objectForKey:@"height"];
    else
        heightString = [NSString stringWithString:@"176.5"];
    
    return heightString;
}

-(NSString *) getWeightDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *weightString;
    
    if ([defaults objectForKey:@"weight"])
        weightString = [defaults objectForKey:@"weight"];
    else
        weightString = [NSString stringWithString:@"70"];
    
    return weightString;
}

-(NSString *) getUnitsDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *unitString;
    
    if ([defaults objectForKey:@"systemUnits"]) 
        unitString = [defaults objectForKey:@"systemUnits"];
    else
        unitString = [NSString stringWithString:@"imperial"];
    
    return unitString;
}

-(NSString *) getUsageDefault
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *usageChoice;
    
    if ([defaults objectForKey:@"usageSharing"]) 
    {
        usageChoice = [defaults objectForKey:@"usageSharing"];
    }
    else 
    {
        usageChoice = [NSString stringWithString: @"Yes"];
    }
    
    return usageChoice;
}

#pragma mark - Save settings

-(void) saveUnitsSetting: (int) unitChoice
{
    int theUnits = unitChoice;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (theUnits == 1) 
        [defaults setObject:@"metric" forKey:@"systemUnits"];
    else
        [defaults setObject:@"imperial" forKey:@"systemUnits"];
}

-(void) saveSexSetting: (int) theSex
{
    int selectedSex = theSex;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (selectedSex == 1)
        [defaults setObject:@"female" forKey:@"gender"];
    else
        [defaults setObject:@"male" forKey:@"gender"];
}

-(void) saveAgeSetting: (NSString *) theAge
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *age = theAge;
    [defaults setObject:age forKey:@"age"]; 
}

-(void) saveHeightSetting: (NSString *) theHeight
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *height = theHeight;
    [defaults setObject:height forKey:@"height"];
}

-(void) saveWeightSetting: (NSString *) theWeight
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *weight = theWeight;
    [defaults setObject:weight forKey:@"weight"];
}

-(void) saveVersion: (NSString *) theVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = theVersion;
    [defaults setObject:version forKey:@"version"];
}

@end
