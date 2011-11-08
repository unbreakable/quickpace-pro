//
//  PaceCalculator.m
//  QuickPace
//
//  Created by Jonathan Kaufman on 9/18/11.
//  Copyright 2011 Unbreakable Apps. All rights reserved.

#import "RunStatsCalculator.h"


@implementation RunStatsCalculator

// Calculate MPH and pace

-(int) paceMinutesGivenMinutes: (float) theMinutes andDistance: (float) theDistance
{
    if ( theDistance > 0 )
        return theMinutes / theDistance;
    else
        return 0.0;
}

-(float) paceSecondsGivenMinutes: (float) theMinutes andDistance: (float) theDistance
{
    if ( theDistance > 0 ) 
    {
        int i;
        float pace = theMinutes / theDistance;
        float paceSec = theMinutes / theDistance;
        for ( i = 1; i <= pace; ++i ) 
        {
            --paceSec;   
        }
        return paceSec * 60;
    }
    else return 0.0;
}

-(NSString *) calculateSpeedGivenHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds andDistance: (NSString *) someDistance;
{
    // Define variables
    float theHours, theMinutes, theSeconds, theDistance, totalRunMinutes, theSpeed;
    NSString *theSpeedResult;

    // Set initial values
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    NSString *userUnits = [NSString stringWithString:[userSettings getUnitsDefault]];
    theHours = [someHours floatValue];
    theMinutes = [someMinutes floatValue];
    theSeconds = [someSeconds floatValue];
    theDistance = [someDistance floatValue];
    
    // Calculate stuff
    totalRunMinutes = (theHours * 60) + theMinutes + (theSeconds / 60);
    
    theSpeed = theDistance / (totalRunMinutes / 60);
    
    if ( theSpeed > 0 )
    {
        if ([userUnits isEqualToString:@"imperial"])
            theSpeedResult = [NSString stringWithFormat: @"%.2f mph", theSpeed];
        else
            theSpeedResult = [NSString stringWithFormat: @"%.2f kph", theSpeed];
    } 
    else
    {
        if ([userUnits isEqualToString:@"imperial"])
            theSpeedResult = [NSString stringWithString: @"0.0 mph"];
        else
            theSpeedResult = [NSString stringWithString: @"0.0 kph"];
    }
    
    return theSpeedResult;
}

 -(NSString *) calculatePaceGivenHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds andDistance: (NSString *) someDistance;
{
    // Define variables
    float theHours, theMinutes, theSeconds, theDistance, totalRunMinutes, thePaceSeconds;
    int thePaceMinutes;
    NSString *thePaceResult;
    
    // Set initial values
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    NSString *userUnits = [NSString stringWithString:[userSettings getUnitsDefault]];
    theHours = [someHours floatValue];
    theMinutes = [someMinutes floatValue];
    theSeconds = [someSeconds floatValue];
    theDistance = [someDistance floatValue];
    totalRunMinutes = (theHours * 60) + theMinutes + (theSeconds / 60);
    thePaceSeconds = [self paceSecondsGivenMinutes:totalRunMinutes andDistance:theDistance];
    thePaceMinutes = [self paceMinutesGivenMinutes:totalRunMinutes andDistance:theDistance];
    
    if ( thePaceSeconds >= 9.449 )
    {
        if ([userUnits isEqualToString:@"imperial"]) {
            thePaceResult = [NSString stringWithFormat:@"%i:%.0f per mile", thePaceMinutes, thePaceSeconds];
        }
        else {
            thePaceResult = [NSString stringWithFormat: @"%i:%.0f per kilometer", thePaceMinutes, thePaceSeconds];
        }
    }
    else
    {
        if ([userUnits isEqualToString:@"imperial"]) {
            thePaceResult = [NSString stringWithFormat:@"%i:0%.0f per mile", thePaceMinutes, thePaceSeconds];
        }
        else {
            thePaceResult = [NSString stringWithFormat: @"%i:0%.0f per kilometer", thePaceMinutes, thePaceSeconds];
        }
    }
    
    return thePaceResult;
}

-(NSString *) calculateCaloriesUsingHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds andDistance: (NSString *) someDistance;
{
    // Define variables
    float theHours, theMinutes, theSeconds, theDistance, totalRunMinutes, theSpeed, m, b, origMETS, correctedMETS, totalRunCalories;
    NSString *theCalorieResult;
    
    // Create constants
    float factorOne = 3.5;
    float factorTwoMale   = 66.5;
    float factorThreeMale = 5.0;
    float factorFourMale  = 13.7;
    float factorFiveMale  = 6.8;
    float factorTwoFemale   = 655.1;
    float factorThreeFemale = 1.8;
    float factorFourFemale  = 9.6;
    float factorFiveFemale  = 4.7;
    
    // Set initial values
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    NSString *userUnits = [NSString stringWithString:[userSettings getUnitsDefault]];
    NSString *userSex   = [NSString stringWithString:[userSettings getSexDefault]];
    float anAge   = [[userSettings    getAgeDefault] floatValue];
    float aWeight = [[userSettings getWeightDefault] floatValue];
    float aHeight = [[userSettings getHeightDefault] floatValue];
    theHours =    [someHours    floatValue];
    theMinutes =  [someMinutes  floatValue];
    theSeconds =  [someSeconds  floatValue];
    theDistance = [someDistance floatValue];
    totalRunMinutes = (theHours * 60) + theMinutes + (theSeconds / 60);
    theSpeed = theDistance / (totalRunMinutes / 60);   
    
    // Interpolate METS value using line equations
    if (theSpeed <=0) 
    {
        m = 0.00;
        b = 1.00;
    }
    else if (theSpeed >0 && theSpeed <=1.5) 
    {
        m = 0.67;
        b = 1.00;
    }
    else if (theSpeed >1.5 && theSpeed <=2) 
    {
        m = 1.60;
        b = -0.40;
    }
    else if (theSpeed >2 && theSpeed <=3) 
    {
        m = 0.70;
        b = 1.40;
    }
    else if (theSpeed >3 && theSpeed <=4) 
    {
        m = 2.30;
        b = -3.40;
    }
    else if (theSpeed >4 && theSpeed <=5) 
    {
        m = 2.50;
        b = -4.20;
    }
    else if (theSpeed >5 && theSpeed <=6) 
    {
        m = 1.50;
        b = 0.80;
    }
    else if (theSpeed >6 && theSpeed <=7) 
    {
        m = 1.20;
        b = 2.60;
    }
    else if (theSpeed >7 && theSpeed <=8) 
    {
        m = 0.80;
        b = 5.40;
    }
    else if (theSpeed >8 && theSpeed <=9) 
    {
        m = 1.00;
        b = 3.80;
    }
    else if (theSpeed >9 && theSpeed <=10) 
    {
        m = 1.70;
        b = -2.50;
    }
    else if (theSpeed >10 && theSpeed <=11) 
    {
        m = 1.50;
        b = -0.50;
    }
    else if (theSpeed >11 && theSpeed <=12) 
    {
        m = 3.00;
        b = -17.00;
    }
    else if (theSpeed >12 && theSpeed <=13) 
    {
        m = 0.80;
        b = 9.40;
    }
    else
    {
        m = 3.20;
        b = -21.80;
    }
    
    origMETS = (m * theSpeed) + b;
    
    // Improve the origMETS by correcting for age, sex, height, and weight
    if ( [userSex isEqualToString:@"male"] )
        correctedMETS = (factorOne/
                         (
                          (
                           (
                            (
                             (factorTwoMale+(factorThreeMale*aHeight)+(factorFourMale*aWeight)-(factorFiveMale*anAge)
                              )/1440
                             )/5
                            )/aWeight
                           )*1000
                          )
                         )*origMETS;
    else
        correctedMETS = (factorOne/
                         (
                          (
                           (
                            (
                             (factorTwoFemale+(factorThreeFemale*aHeight)+(factorFourFemale*aWeight)-(factorFiveFemale*anAge)
                              )/1440
                             )/5
                            )/aWeight
                           )*1000
                          )
                         )*origMETS;
    
    totalRunCalories = ( ( correctedMETS * aWeight * 3.5 ) / 200 ) * totalRunMinutes;
    
    // Final result formatting
    if ( totalRunCalories <= 0 || isnan(totalRunCalories))
    {
        if ( [userUnits isEqualToString:@"imperial"] )
            theCalorieResult = [NSString stringWithString:@"0.0 calories"];
        else
            theCalorieResult = [NSString stringWithString:@"0.0 kilocalories"];
    }
    else
    {
        if ( [userUnits isEqualToString:@"imperial"] )
            theCalorieResult = [NSString stringWithFormat: @"%.1f calories", totalRunCalories];
        else
            theCalorieResult = [NSString stringWithFormat: @"%.1f kilocalories", totalRunCalories];
    }
    
    return theCalorieResult;
}

@end

