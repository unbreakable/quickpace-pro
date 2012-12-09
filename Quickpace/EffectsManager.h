//
//  EffectsManager.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EffectsManager : NSObject

// Fade in and out
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;
-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait;

//TEST for GIT ...THIS IS THE PRO CODE

@end
