//
//  EffectsManager.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EffectsManager.h"

@implementation EffectsManager

-(void) fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView beginAnimations: @"Fade Out" context:nil];
	
	// Wait for time before begin
	[UIView setAnimationDelay:wait];
	
	// Duration of animation
	[UIView setAnimationDuration:duration];
	viewToDissolve.alpha = 0.0;
	[UIView commitAnimations];
}

-(void)fadeIn:(UIView *)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
	[UIView beginAnimations: @"Fade In" context:nil];
	
	// Wait for time before begin
	[UIView setAnimationDelay:wait];
    
    // Duration of animation
	[UIView setAnimationDuration:duration];
	viewToFadeIn.alpha = 1;
	[UIView commitAnimations];
	
}

@end
