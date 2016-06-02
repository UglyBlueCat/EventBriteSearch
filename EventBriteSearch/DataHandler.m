//
//  DataHandler.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "DataHandler.h"

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
 * Save a set of data to the store
 */
- (void) saveData:(NSData*)data {
    NSError* error;
    NSDictionary* wholeData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%s JSON Conversion error: %@", __PRETTY_FUNCTION__, error);
    } else {
        for (NSDictionary* event in wholeData[@"events"]) {
            NSString* name = event[@"name"][@"text"];
            NSString* logo = event[@"logo"][@"text"];
            NSString* start = event[@"name"][@"text"];
            NSString* end = event[@"name"][@"text"];
        }
    }
}

@end
