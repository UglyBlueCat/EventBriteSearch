//
//  DataHandler.h
//  EventBriteSearch
//
//  Created by Robin Spinks on 01/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandler : NSObject

+ (DataHandler*)sharedInstance;
- (void) saveData:(NSData*)data;

@end
