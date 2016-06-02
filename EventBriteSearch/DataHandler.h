//
//  DataHandler.h
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject

/**
 * Access the shared instance
 */
+ (DataHandler*)sharedInstance;

/**
 * Save a set of data for a city
 *
 * @param:(NSData*)data
 *      - The data to store
 *
 * @param:(NSString*)city
 *      - The city the data is for
 */
- (void) saveData:(NSData*)data withCity:(NSString*)city;

/**
 * Return a set of data for a city
 *
 * @param:(NSString*)city
 *      - The city the data is for
 *
 * @return:NSArray
 *      - An array containing the events
 */
- (NSArray*)eventsForCity:(NSString*)city;

@end
