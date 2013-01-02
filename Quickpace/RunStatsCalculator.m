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

-(float) totalRunInMinutesGivenHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds 
{
    // Define variables
    float theHours, theMinutes, theSeconds, totalRunMinutes;
    
    // Set initial values
    theHours = [someHours floatValue];
    theMinutes = [someMinutes floatValue];
    theSeconds = [someSeconds floatValue];
    
    // Calculate
    totalRunMinutes = (theHours * 60) + theMinutes + (theSeconds / 60);
    
    return totalRunMinutes;
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
            theSpeedResult = @"0.0 mph";
        else
            theSpeedResult = @"0.0 kph";
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
    
    if ( thePaceSeconds >= 59.449 )
    {
        // If the seconds round up to 60, then make them "00" and add 1 to the minutes
        if ([userUnits isEqualToString:@"imperial"]) {
            thePaceResult = [NSString stringWithFormat:@"%i:00 per mile", thePaceMinutes+1];
        }
        else {
            thePaceResult = [NSString stringWithFormat:@"%i:00 per km", thePaceMinutes+1];
        }
    }
    else if ( thePaceSeconds >= 9.449 )
    {
        // If the seconds will be double digit (>=10 basically) just display paceSeconds as is.
        if ([userUnits isEqualToString:@"imperial"]) {
            thePaceResult = [NSString stringWithFormat:@"%i:%.0f per mile", thePaceMinutes, thePaceSeconds];
        }
        else {
            thePaceResult = [NSString stringWithFormat: @"%i:%.0f per km", thePaceMinutes, thePaceSeconds];
        }
    }
    else
    {
        // If the seconds will be single digit (<10 basically) add a zero so the MM:SS displays right.
        if ([userUnits isEqualToString:@"imperial"]) {
            thePaceResult = [NSString stringWithFormat:@"%i:0%.0f per mile", thePaceMinutes, thePaceSeconds];
        }
        else {
            thePaceResult = [NSString stringWithFormat: @"%i:0%.0f per km", thePaceMinutes, thePaceSeconds];
        }
    }
    
    return thePaceResult;
}

-(NSString *) calculateCaloriesUsingHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds andDistance: (NSString *) someDistance andIncline: (NSString *) someIncline;
{
    // Define variables
    float theHours, theMinutes, theSeconds, theDistance, theIncline, totalRunMinutes, theSpeed, m, b, inclFactor, origMETS, correctedMETs, totalRunCalories, inclineMETs, finalMETs;
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
    
    // Set initial values with user inputs or defaults
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
    theIncline = [someIncline floatValue];
    totalRunMinutes = (theHours * 60) + theMinutes + (theSeconds / 60);
    theSpeed = theDistance / (totalRunMinutes / 60);  
    
    // Set variables to interpolate zero incline METS value using a set of line equations
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
    
    // Calculate flat ground METs
    origMETS = (m * theSpeed) + b;
    
    // Set the incline (aka grade) factor dependent on whether the person is probably running or walking
    if (theSpeed <=0)
    {
        inclFactor = 0;
    }
    else if (theSpeed >0 && theSpeed <=3.5)
    {
        inclFactor = 1.8;
    }
    else
    {
        inclFactor = 0.9;
    }
    
    // Calculate additional METs that come from the incline
    inclineMETs = ((theIncline / 100) * (theSpeed * 26.8) * inclFactor) /  factorOne;
    
    // Add origMETs to inclineMETs to get finalMETs
    finalMETs = origMETS + inclineMETs;
    
    // NSLog(@"finalMETs are %f adding orig of %f and incline METs of %f", finalMETs, origMETS, inclineMETs);
    
    // Improve the finalMETs by correcting for age, sex, height, and weight
    if ( [userSex isEqualToString:@"male"] )
        correctedMETs = (factorOne/
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
                         )*finalMETs;
    else
        correctedMETs = (factorOne/
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
                         )*finalMETs;
    
    // NSLog(@"correctedMets are adjusted to %f at an incline of %f", correctedMETs, theIncline);
    
    totalRunCalories = ( ( correctedMETs * aWeight * 3.5 ) / 200 ) * totalRunMinutes;
    
    // Final result formatting
    if ( totalRunCalories <= 0 || isnan(totalRunCalories))
    {
        if ( [userUnits isEqualToString:@"imperial"] )
            theCalorieResult = @"0.0 calories";
        else
            theCalorieResult = @"0.0 kilocalories";
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

