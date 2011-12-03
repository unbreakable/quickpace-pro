//
//  Run.h
//  Quickpace
//
//  Created by Jonathan Kaufman on 12/2/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Run : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * pace;
@property (nonatomic, retain) NSString * distance;

@end
