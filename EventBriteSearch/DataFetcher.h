//
//  DataFetcher.h
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

+ (DataFetcher*)sharedInstance;
- (void)downloadEventsForCity:(NSString*)city
            completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

@end
