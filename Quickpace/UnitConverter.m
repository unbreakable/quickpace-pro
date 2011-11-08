//
//  UnitConverter.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "UnitConverter.h"

@implementation UnitConverter

@synthesize pounds, kilograms, centimeters, feet, inches, hours, minutes, seconds;

-(NSString *) convertToKilogramsGivenLbs: (NSString *) poundsToConvert
{
    float cvtPounds = [poundsToConvert floatValue];
    float resultNum = cvtPounds * 0.45359237;
    NSString *result = [NSString stringWithFormat:@"%.1f", resultNum];
    return result;
}

-(NSString *) convertToPoundsGivenKgs: (NSString *) kilogramsToConvert
{
    float cvtKilos = [kilogramsToConvert floatValue];
    float resultNum = cvtKilos * 2.20462262;
    NSString *result = [NSString stringWithFormat:@"%.1f", resultNum];
    return result;
}

-(NSString *) convertToCentimetersGivenFeetInches: (NSDictionary *) feetInchesToConvert
{
    NSDictionary *heightMeasurements = [NSDictionary dictionaryWithDictionary:feetInchesToConvert];
    NSNumber *feetObj = [heightMeasurements  objectForKey:@"feet"];
    NSNumber *inchObj = [heightMeasurements objectForKey:@"inches"]; 
    float feetHigh = [feetObj floatValue];
    float inchesHigh = [inchObj floatValue];
    
    float totalInches = ( feetHigh * 12 ) + inchesHigh;
    float resultNum = totalInches * 2.54;
    NSString *result = [NSString stringWithFormat:@"%.1f", resultNum];
    return result;
}

-(NSDictionary *) convertToFeetInchesGivenCentimeters: (NSString *) centimetersToConvert
{
    float cvtCents, resultNum, inchesWork, justInches;
    int justFeet;
    NSString *justFeetStr, *justInchesStr;
    NSDictionary *results;
    
    cvtCents = [centimetersToConvert floatValue]; // Make the string a number
    resultNum = cvtCents * 0.393700787; // Convert to inches only
    
    // Figure out the feet using an INT variable (to strip off the remainder)
    if (resultNum > 0)
        justFeet = resultNum / 12;
    else
        justFeet = 0;
    justFeetStr = [NSString stringWithFormat:@"%i", justFeet];
    
    // Figure out the inches by subtracting "(int) feet" from "(float) feet"
    if (resultNum >0)
    {
        inchesWork = ( resultNum / 12 ) - justFeet;
    }
    else
        inchesWork = 0.0;
    justInches = inchesWork * 12;
    
    // Create inches output string
    justInchesStr = [NSString stringWithFormat:@"%.1f", justInches];
    
    // Stuff everything into a package to send back
    results = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            justFeetStr, @"feet", 
                                            justInchesStr, @"inches", 
                                            nil];
    
    return results;
}

@end
