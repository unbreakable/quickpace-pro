//
//  FlipsideViewController.m
//  Quickpace
//
//  Created by Jonathan Kaufman on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate = _delegate, unitsPicker, ageEntry, metricHeightEntry, metricWeightEntry, sexPicker, keyboardDismisser, feetEntry, inchEntry, imperialWeightEntry, feetInchMarkers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Set accessibility labels so test automation can read them
    unitsPicker.accessibilityLabel = @"unitsPicker";
    unitsPicker.isAccessibilityElement = YES;
    sexPicker.accessibilityLabel = @"sexPicker";
    sexPicker.isAccessibilityElement = YES;
    
    // Pull defaults and set values on screen
    [self getAllSettingsInFlip];
    
    // Check for units and only show the applicable fields for weight and set labels for the appropriate system
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    if ( [[userSettings getUnitsDefault] isEqualToString:@"imperial"] ) 
    {
        metricHeightEntry.alpha = 0;
        metricWeightEntry.alpha = 0;
        
        feetEntry.alpha = 1;
        inchEntry.alpha = 1;
        feetInchMarkers.alpha = 1;
        imperialWeightEntry.alpha = 1;
    }
    else
    {
        metricHeightEntry.alpha = 1;
        metricWeightEntry.alpha = 1;
        
        feetEntry.alpha = 0;
        inchEntry.alpha = 0;
        feetInchMarkers.alpha = 0;
        imperialWeightEntry.alpha = 0;
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) || 
            (interfaceOrientation == UIInterfaceOrientationPortrait));
}

#pragma mark - Keyboard scrolling methods

- (void) keyboardWillShow: (NSNotification *) notif 
{
	NSDictionary *info = [notif userInfo];
	NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    float bottomPoint = 0;
    
    if ([ageEntry isFirstResponder]) 
        bottomPoint = (ageEntry.frame.origin.y+ageEntry.frame.size.height+8);
    else if ([metricHeightEntry isFirstResponder])
        bottomPoint = (metricHeightEntry.frame.origin.y+metricHeightEntry.frame.size.height+8);
    else if ([metricWeightEntry isFirstResponder])
        bottomPoint = (metricWeightEntry.frame.origin.y+metricWeightEntry.frame.size.height+8);
    else if ([imperialWeightEntry isFirstResponder])
        bottomPoint = (imperialWeightEntry.frame.origin.y+imperialWeightEntry.frame.size.height+8);
    else if ([feetEntry isFirstResponder])
        bottomPoint = (feetEntry.frame.origin.y+feetEntry.frame.size.height+8);
    else if ([inchEntry isFirstResponder])
        bottomPoint = (inchEntry.frame.origin.y+inchEntry.frame.size.height+8);
    
	scrollAmount = keyboardSize.height - (self.view.frame.size.height - bottomPoint);
	
	if (scrollAmount >0) 
    {
		moveViewUp = YES;
		[self scrollTheView:YES];
	}
	else
		moveViewUp = NO;
}

- (void) scrollTheView: (BOOL) movedUp 
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	CGRect rect = self.view.frame;
	if (movedUp) 
    {
		rect.origin.y -= scrollAmount;
        self.view.frame = rect;
        [UIView commitAnimations];
	} 
    else 
    {
		rect.origin.y += scrollAmount;
        self.view.frame = rect;
        [UIView commitAnimations];
        scrollAmount = 0;
	}
}

#pragma mark - Actions
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    if (moveViewUp) [self scrollTheView:NO];
	
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded: (NSSet *)touches withEvent: (UIEvent *)event 
{
    for (UIView* view in self.view.subviews) 
    {
        if ([view isKindOfClass:[UITextField class]])
            [view resignFirstResponder];
    }
}

// General note this method only works when the view controller is hooked up as the delegate in IB  
- (BOOL) textFieldShouldReturn: (UITextField *) theTextField 
{
    if (theTextField == feetEntry) 
    {
        [inchEntry becomeFirstResponder];
        return NO;
    }
    else
    {
        [ageEntry becomeFirstResponder];
        [ageEntry resignFirstResponder];
    }
    if (moveViewUp) [self scrollTheView:NO];
    
    [FlurryAnalytics logEvent:@"Keyboard 'Return' key used in Settings view"];
    
    return YES;
}

-(IBAction) saveUnitsSetting
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    EffectsManager *uiEffects = [[EffectsManager alloc] init];
    
    [userSettings saveUnitsSetting:unitsPicker.selectedSegmentIndex];
    
	if ( [[userSettings getUnitsDefault] isEqualToString:@"imperial"] ) 
    {
        [uiEffects fadeOut: metricHeightEntry  withDuration: 0.3 andWait: 0.1];
        [uiEffects fadeOut: metricWeightEntry  withDuration: 0.3 andWait: 0.1];
        
        [uiEffects fadeIn: feetEntry           withDuration: 0.3 andWait: 0.4];
        [uiEffects fadeIn: inchEntry           withDuration: 0.3 andWait: 0.4];
        [uiEffects fadeIn: feetInchMarkers     withDuration: 0.3 andWait: 0.4];
        [uiEffects fadeIn: imperialWeightEntry withDuration: 0.3 andWait: 0.4];
        
        if ( [metricHeightEntry isFirstResponder] )
        {
            [metricHeightEntry resignFirstResponder];
            if (moveViewUp) [self scrollTheView:NO];
        } else if ( [metricWeightEntry isFirstResponder] )
        {
            [metricWeightEntry resignFirstResponder];
            if (moveViewUp) [self scrollTheView:NO];
        }
        
        [FlurryAnalytics logEvent:@"User picked Imperial setting"];
    }
    else 
    {
        [uiEffects fadeOut: feetEntry           withDuration: 0.3 andWait: 0.1];
        [uiEffects fadeOut: inchEntry           withDuration: 0.3 andWait: 0.1];
        [uiEffects fadeOut: imperialWeightEntry withDuration: 0.3 andWait: 0.1];
        [uiEffects fadeOut: feetInchMarkers     withDuration: 0.3 andWait: 0.1];
        
        [uiEffects fadeIn: metricHeightEntry    withDuration: 0.3 andWait: 0.4];
        [uiEffects fadeIn: metricWeightEntry    withDuration: 0.3 andWait: 0.4];
        
        if ( [feetEntry isFirstResponder] )
        {
            [feetEntry resignFirstResponder];
            if (moveViewUp) [self scrollTheView:NO];
        } else if ( [inchEntry isFirstResponder] )
        {
            [inchEntry resignFirstResponder];
            if (moveViewUp) [self scrollTheView:NO];
        } else if ( [imperialWeightEntry isFirstResponder] )
        {
            [imperialWeightEntry resignFirstResponder];
            if (moveViewUp) [self scrollTheView:NO];
        }
        
        [FlurryAnalytics logEvent:@"User picked Metric setting"];
    }
}

-(IBAction) saveSexSetting
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    [userSettings saveSexSetting:sexPicker.selectedSegmentIndex];
    
    NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:[userSettings getSexDefault], @"userSex", nil];
    [FlurryAnalytics logEvent:@"Sex chosen" withParameters:flurryDic];
}

-(IBAction) saveAgeSetting
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    
    [userSettings saveAgeSetting:ageEntry.text];
    
    NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:[userSettings getAgeDefault], @"userAge", nil];
    [FlurryAnalytics logEvent:@"Age chosen" withParameters:flurryDic];
}

-(IBAction) saveHeightSetting
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    if ([[userSettings getUnitsDefault] isEqualToString:@"metric"])
    {
        // Convert to imperial and display
        NSDictionary *imperialHeightValues = [converter convertToFeetInchesGivenCentimeters:metricHeightEntry.text];
        feetEntry.text = [NSString stringWithString:[imperialHeightValues objectForKey:@"feet"]];
        inchEntry.text = [NSString stringWithString:[imperialHeightValues objectForKey:@"inches"]];
        
        NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:metricHeightEntry.text, @"userHeight", @"Metric", @"units", nil];
        [FlurryAnalytics logEvent:@"Height chosen" withParameters:flurryDic];
    }
    else
    {
        // Package
        NSDictionary *imperialHeightValues = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              feetEntry.text, @"feet", 
                                              inchEntry.text, @"inches", 
                                              nil];
        // Convert to metric and display
        metricHeightEntry.text = [NSString stringWithString:[converter convertToCentimetersGivenFeetInches: imperialHeightValues]];
        
        NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:metricHeightEntry.text, @"userHeight", @"Imperial", @"units", nil];
        [FlurryAnalytics logEvent:@"Height chosen" withParameters:flurryDic];
    }
    [userSettings saveHeightSetting:metricHeightEntry.text];
}

-(IBAction) saveWeightSetting
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    UnitConverter *converter = [[UnitConverter alloc] init];
    
    if ( [[userSettings getUnitsDefault] isEqualToString:@"metric"] )
    {
        imperialWeightEntry.text = [NSString stringWithString:[converter convertToPoundsGivenKgs:metricWeightEntry.text]];        
        
        NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:imperialWeightEntry.text, @"userWeight", @"Imperial", @"units", nil];
        [FlurryAnalytics logEvent:@"Weight chosen" withParameters:flurryDic];
    }
    else
    {
        metricWeightEntry.text = [NSString stringWithString:[converter convertToKilogramsGivenLbs:imperialWeightEntry.text]];
        
        NSDictionary *flurryDic = [[NSDictionary alloc] initWithObjectsAndKeys:metricWeightEntry.text, @"userWeight", @"Metric", @"units", nil];
        [FlurryAnalytics logEvent:@"Weight chosen" withParameters:flurryDic];
    }
    
    [userSettings saveWeightSetting:metricWeightEntry.text];
}

-(void) getAllSettingsInFlip
{
    SettingsManager *userSettings = [[SettingsManager alloc] initWithSettings];
    UnitConverter *converter = [[UnitConverter alloc] init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Put the settings values on the screen
    if ( [[defaults objectForKey:@"age"] length] != 0 )
        ageEntry.text = [NSString stringWithString:[userSettings getAgeDefault]];
    if ( [[defaults objectForKey:@"height"] length] != 0 )
    {
        metricHeightEntry.text = [NSString stringWithString:[userSettings getHeightDefault]];
        NSDictionary *imperialHeightValues = [converter convertToFeetInchesGivenCentimeters:metricHeightEntry.text];
        feetEntry.text = [NSString stringWithString:[imperialHeightValues objectForKey:@"feet"]];
        inchEntry.text = [NSString stringWithString:[imperialHeightValues objectForKey:@"inches"]];
    }
    if ( [[defaults objectForKey:@"weight"] length] != 0 )
    {
        metricWeightEntry.text = [NSString stringWithString: [userSettings getWeightDefault]];
        imperialWeightEntry.text = [NSString stringWithString:[converter convertToPoundsGivenKgs:[userSettings getWeightDefault]]];
    }
    
    if ([[userSettings getUnitsDefault] isEqualToString:@"metric"])
        unitsPicker.selectedSegmentIndex = 1;
    else
        unitsPicker.selectedSegmentIndex = 0;
    
    if ([[userSettings getSexDefault] isEqualToString:@"female"])
        sexPicker.selectedSegmentIndex = 1;
    else
        sexPicker.selectedSegmentIndex = 0;
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
