//
//  Attendee+CoreDataProperties.h
//  Attendance
//
//  Created by Adam Gall on 8/4/16.
//  Copyright © 2016 gallio. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Attendee.h"

NS_ASSUME_NONNULL_BEGIN

@interface Attendee (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *phone;

@end

NS_ASSUME_NONNULL_END
