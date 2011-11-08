//
//  SettingsManager.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject
{
    NSDictionary *settings;
}

-(id) init;
-(id) initWithSettings;

-(NSDictionary *) getAllSettings;
-(NSString *) getSexDefault;
-(NSString *) getAgeDefault;
-(NSString *) getHeightDefault;
-(NSString *) getWeightDefault;
-(NSString *) getUnitsDefault;
-(NSString *) getUsageDefault;

-(void) saveSexSetting: (int) theSex;
-(void) saveAgeSetting: (NSString *) theAge;
-(void) saveHeightSetting: (NSString *) theHeight;
-(void) saveWeightSetting: (NSString *) theWeight;
-(void) saveUnitsSetting: (int) unitChoice;
-(void) saveVersion: (NSString *) theVersion;

@end
