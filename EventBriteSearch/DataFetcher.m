//
//  DataFetcher.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "DataFetcher.h"

/**
 * Use a macro for the URL and token as they are fixed for now
 */
#define BASE_URL @"https://www.eventbriteapi.com/v3/events/search/"
#define TOKEN @"UPCEJY23QCH25H7NPDY3"

@implementation DataFetcher

/**
 * Make the DataFetcher a singleton
 */
+ (DataFetcher*)sharedInstance {
    static DataFetcher* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [DataFetcher new];
    });
    return _sharedInstance;
}

/**
 * Download events for a city and save it to the data store
 */
- (void)downloadEventsForCity:(NSString*)city
            completionHandler:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    
    NSDictionary* params = @{@"venue.city": city, @"token": TOKEN};
//    [self fetchDataFromURL:BASE_URL
//            withParameters:params
//         completionHandler:completion];
    [self fetchDataFromURL:BASE_URL withParameters:params success:success];
}

/**
 * fetch data from a URL as a GET request with parameters and completion block
 *
 * @param:(NSString*)url
 *         - The base URL
 *
 * @param:(NSDictionary*)parameters
 *         - The parameters to pass to the GET request
 *
 * @param:(void (^)(AFHTTPRequestOperation *operation, id responseObject))completion
 *         - The completion block
 */
- (void)fetchDataFromURL:(NSString*)url withParameters:(NSDictionary*)parameters
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url
      parameters:parameters
         success:success
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%s Error fetching data: %@", __PRETTY_FUNCTION__, error.description);
         }];
}
/*
- (void)fetchDataFromURL:(NSString*)url
          withParameters:(NSDictionary*)parameters
       completionHandler:(void (^)(NSURLResponse* response, id responseObject, NSError* error))completion {
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest* request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:url
                                                                         parameters:parameters
                                                                              error:nil];
    
    NSURLSessionDataTask* dataTask = [manager dataTaskWithRequest:request
                                                completionHandler:completion];
    [dataTask resume];
}
 */

@end
