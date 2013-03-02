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

// perhaps use RunStatsCalculator class instead of feeding RunTime from MainView
// perhaps use SettingsManager class instead of feeding Units from MainView
// perhaps use RunStatsCalculator class instead feeding Pace from MainView
// perhaps use RunStatsCalculator class instead feeding Calories from MainView
-(NSString *) createShareTextUsingHours: (NSString *) someHours
                             andMinutes: (NSString *) someMinutes
                             andSeconds: (NSString *) someSeconds
                            andDistance: (NSString *) someDistance
                             andIncline: (NSString *) someIncline;

@end
