//
//  Event+CoreDataProperties.h
//  EventBriteSearch
//
//  Created by Robin Spinks on 02/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *end;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *start;
@property (nullable, nonatomic, retain) NSString *eventid;
@property (nullable, nonatomic, retain) NSString *city;

@end

NS_ASSUME_NONNULL_END
