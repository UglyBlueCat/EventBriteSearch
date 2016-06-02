//
//  DataHandler.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "DataHandler.h"
#import "Event.h"
#import "DataFetcher.h"

@implementation DataHandler

/**
 * Make the DataHandler a singleton
 */
+ (DataHandler*)sharedInstance {
    static DataHandler* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [DataHandler new];
    });
    return _sharedInstance;
}

/**
 * Save a set of data for a city
 *
 * @param:(NSData*)data
 *      - The data to store
 *
 * @param:(NSString*)city
 *      - The city the data is for
 */
- (void) saveData:(NSData*)data withCity:(NSString*)city {
    NSError* error;
    NSDictionary* wholeData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    DataFetcher* __block dataFetcher = [DataFetcher sharedInstance];
    if (error) {
        NSLog(@"%s JSON Conversion error: %@", __PRETTY_FUNCTION__, error);
    } else {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext) {
            for (NSDictionary* event in wholeData[@"events"]) {
                Event* newEvent;
                if (event[@"id"] && [event[@"id"] isKindOfClass:[NSString class]]) {
                    newEvent = [Event MR_findFirstOrCreateByAttribute:@"eventid"
                                                                   withValue:event[@"id"]
                                                                   inContext:localContext];
                    if ([self checkDatum:event[@"name"] forKey:@"text"]) {
                        newEvent.name = event[@"name"][@"text"];
                    }
                    if ([self checkDatum:event[@"logo"] forKey:@"url"]) {
                        newEvent.logo = event[@"logo"][@"url"];
                    }
                    if ([self checkDatum:event[@"start"] forKey:@"utc"]) {
                        newEvent.start = event[@"start"][@"utc"];
                    }
                    if ([self checkDatum:event[@"end"] forKey:@"utc"]) {
                        newEvent.end = event[@"end"][@"utc"];
                    }
                    newEvent.city = city;
                }
                if (newEvent.logo) {
                    [dataFetcher fetchImageForEventID:newEvent.eventid fromURL:newEvent.logo];
                }
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if ( ! contextDidSave) {
                NSLog(@"%s Error saving: %@", __PRETTY_FUNCTION__, error.debugDescription);
            }
            NSDictionary* userInfo = @{@"didComplete":[NSNumber numberWithBool:contextDidSave]};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataDidFinishloading"
                                                                object:nil
                                                              userInfo:userInfo];
        }];
    }
}

/**
 * Checks a data object is not null, is an NSDictionary and contains a value for a specified key
 *
 * @param: (id)datum
 *      - The data object to be checked
 *
 * @param: (NSString*)key
 *      - The key to check the NSDictionary for
 *
 * @return: BOOL
 *      - Confirmation that the data object passed all tests
 */
- (BOOL)checkDatum:(id)datum forKey:(NSString*)key {
    
    if ( ! datum) {
        return FALSE;
    }
    
    if ( ! [datum isKindOfClass:[NSDictionary class]]) {
        return FALSE;
    }
    
    if ( ! [[(NSDictionary*)datum allKeys] containsObject:key]) {
        return FALSE;
    }
    
    return TRUE;
}

/**
 * Return a set of data for a city
 *
 * @param:(NSString*)city
 *      - The city the data is for
 *
 * @return:NSArray
 *      - An array containing the events
 */
- (NSArray*)eventsForCity:(NSString*)city {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"city == %@", city];
    return [Event MR_findAllWithPredicate:predicate];
}

@end
