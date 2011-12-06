//
//  RunDetailViewController.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 12/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Run;

@interface RunDetailViewController : UITableViewController
{
    Run *run;
}

@property (nonatomic, retain) Run *run;

@end
