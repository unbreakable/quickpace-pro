//
//  RunStatsCalculator.h
//  QuickPace
//
//  Created by Jonathan Kaufman on 9/18/11.
//  Copyright 2011 Unbreakable Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingsManager.h"
#import "UnitConverter.h"

@interface RunStatsCalculator : NSObject 
{
    
}

-(int)   paceMinutesGivenMinutes: (float) theMinutes 
                     andDistance: (float) theDistance;
-(float) paceSecondsGivenMinutes: (float) theMinutes 
                     andDistance: (float) theDistance;
-(float) totalRunInMinutesGivenHours: (NSString *) someHours
                          andMinutes: (NSString *) someMinutes
                          andSeconds: (NSString *) someSeconds;
-(NSString *) calculateSpeedGivenHours: (NSString *) someHours
                            andMinutes: (NSString *) someMinutes 
                            andSeconds: (NSString *) someSeconds 
                           andDistance: (NSString *) someDistance;
-(NSString *)  calculatePaceGivenHours: (NSString *) someHours 
                            andMinutes: (NSString *) someMinutes 
                            andSeconds: (NSString *) someSeconds 
                           andDistance: (NSString *) someDistance;
-(NSString *) calculateCaloriesUsingHours: (NSString *) someHours
                               andMinutes: (NSString *) someMinutes
                               andSeconds: (NSString *) someSeconds
                              andDistance: (NSString *) someDistance
                               andIncline: (NSString *) someIncline;

@end