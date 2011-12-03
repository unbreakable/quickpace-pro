//
//  HistoryViewController.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 12/1/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UITableViewController
{
    NSMutableArray *historyArray;
}

@property (strong, nonatomic) NSMutableArray *historyArray;

- (void)loadHistory;

@end
