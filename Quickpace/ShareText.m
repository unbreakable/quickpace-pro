//
//  ShareText.m
//  QuickpacePro
//
//  Created by JFK on 3/1/13.
//
//

#import "ShareText.h"

@implementation ShareText

-(NSString *) createShareTextUsingHours: (NSString *) someHours andMinutes: (NSString *) someMinutes andSeconds: (NSString *) someSeconds andDistance: (NSString *) someDistance andIncline: (NSString *) someIncline {
    
    NSString *thePace, *theCalories, *theUnits, *runTime, *inclinePhrase, *hoursBlurb, *minutesBlurb, *secondsBlurb;
    
    // Get run calculations for pace and calories
    RunStatsCalculator *theRunStats = [[RunStatsCalculator alloc] init];
    thePace = [theRunStats calculatePaceGivenHours:someHours
                                        andMinutes:someMinutes
                                        andSeconds:someSeconds
                                       andDistance:someDistance];
    theCalories = [theRunStats calculateCaloriesUsingHours:someHours
                                                andMinutes:someMinutes
                                                andSeconds:someSeconds
                                               andDistance:someDistance
                                                andIncline:someIncline];
    
    // Get the units to append to the "I just ran X [miles/km]" phrase
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] ) {
        theUnits = @"km";
    } else {
        if ( [someDistance floatValue] == 1 ) {
            theUnits = @"mile";
        } else {
            theUnits = @"miles";
        }
    }
    
    // If incline is empty just end the sentence. Otherwise drop in the incline phrase.
    if ( [someIncline isEqualToString: @""] ) {
        inclinePhrase = [NSString stringWithFormat: @""];
    } else {
        inclinePhrase = [NSString stringWithFormat: @" at a %@%% incline", someIncline];
    }
    
    if ( [someHours isEqualToString: @""] || [someHours isEqualToString: @"00"] ) {
        hoursBlurb = @"";
    } else {
        hoursBlurb = [NSString stringWithFormat: @"%@:", someHours];
    }
    
    if ( [someMinutes isEqualToString: @""] || [someMinutes isEqualToString: @"00"] ) {
        minutesBlurb = @"00";
    } else if ( [someMinutes floatValue] > 0 && [someMinutes floatValue] < 10 ) {
        minutesBlurb = [NSString stringWithFormat: @"0%@", someMinutes];
    } else {
        minutesBlurb = someMinutes;
    }
    
    if ( [someSeconds isEqualToString: @""] ) {
        secondsBlurb = @"";
    } else if ( [someSeconds floatValue] > 0 && [someSeconds floatValue] < 10 ) {
        secondsBlurb = [NSString stringWithFormat: @":0%@", someSeconds];
    } else if ( [someSeconds isEqualToString: @"00"] ) {
        secondsBlurb = @":00";
    } else {
        secondsBlurb = [NSString stringWithFormat: @":%@", someSeconds];
    }
    
    // If only minutes are specified, make it more readable by saying "I ran x miles in y minutes..."
    if ( ([someHours isEqualToString: @""] || [someHours isEqualToString: @"00"]) && ([someSeconds isEqualToString: @""] || [someSeconds isEqualToString: @"00"]) ){
        if ( [someMinutes floatValue] == 1 ) {
            minutesBlurb = [NSString stringWithFormat: @"%@ minute", someMinutes];
        } else {
            minutesBlurb = [NSString stringWithFormat: @"%@ minutes", someMinutes];
        }
        hoursBlurb = @"";
        secondsBlurb = @"";
    }
    
    // If only hours are specified, make it more readable by saying "I ran x miles in y hours..."
    if ( ([someMinutes isEqualToString: @""] || [someMinutes isEqualToString: @"00"]) && ([someSeconds isEqualToString: @""] || [someSeconds isEqualToString: @"00"]) ) {
        if ( [someHours floatValue] == 1 ) {
            hoursBlurb = [NSString stringWithFormat: @"%@ hour", someHours];
        } else {
            hoursBlurb = [NSString stringWithFormat: @"%@ hours", someHours];
        }
        minutesBlurb = @"";
        secondsBlurb = @"";
    }
    
    runTime = [NSString stringWithFormat: @"%@%@%@", hoursBlurb, minutesBlurb, secondsBlurb];
    
    NSString *textToShare = [NSString stringWithFormat: @"I ran %@ %@ in %@%@. Quickpace Pro calculated my pace at %@ and I burned %@.", someDistance, theUnits, runTime, inclinePhrase, thePace, theCalories];
    
    return textToShare;
}

@end
