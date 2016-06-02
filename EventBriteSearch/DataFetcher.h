//
//  DataFetcher.h
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

/**
 * Access the shared instance
 */
+ (DataFetcher*)sharedInstance;

/**
 * Download events for a city and save it to the data store
 */
- (void)downloadEventsForCity:(NSString*)city
            completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

/**
 * Download data from URL
 */
- (void)downloadDataFromURL:(NSString*)url
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

/**
 * Download an image and store on the filesystem if it doesn't exist
 *
 * @param:(NSString*)eventID
 *      - The ID of the event the image is for
 *
 * @param:(NSString*)imageURL
 *      - The URL to download the image from
 */

- (void)fetchImageForEventID:(NSString*)eventID fromURL:(NSString*)imageURL;

@end
