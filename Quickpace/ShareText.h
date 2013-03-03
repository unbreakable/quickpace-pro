//
//  ShareText.h
//  QuickpacePro
//
//  Created by JFK on 3/1/13.
//
//

#import <Foundation/Foundation.h>
#import "SettingsManager.h"
#import "RunStatsCalculator.h"

@interface ShareText : NSObject {
    
}

-(NSString *) createShareTextUsingHours: (NSString *) someHours
                             andMinutes: (NSString *) someMinutes
                             andSeconds: (NSString *) someSeconds
                            andDistance: (NSString *) someDistance
                             andIncline: (NSString *) someIncline;

@end
