//
//  UnitConverter.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitConverter : NSObject
{
    NSString *pounds;
    NSString *kilograms;
    NSString *centimeters;
    NSString *feet;
    NSString *inches;
    
    NSString *hours;
    NSString *minutes;
    NSString *seconds;
}

@property (nonatomic, retain) NSString *pounds, *kilograms, *centimeters, *feet, *inches, *hours, *minutes, *seconds;

-(NSString *) convertToKilogramsGivenLbs: (NSString *) poundsToConvert;
-(NSString *) convertToPoundsGivenKgs: (NSString *) kilogramsToConvert;
-(NSString *) convertToCentimetersGivenFeetInches: (NSDictionary *) feetInchesToConvert;
-(NSDictionary *) convertToFeetInchesGivenCentimeters: (NSString *) centimetersToConvert;

@end
