//
//  MainViewController.m
//  Attendance
//
//  Created by Adam Gall on 8/4/16.
//  Copyright © 2016 gallio. All rights reserved.
//

#import "AppDelegate.h"
#import "Attendee.h"
#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) IBOutlet UIButton *export;
@property (nonatomic, strong) IBOutlet UILabel *savedAttendees;

@property (nonatomic, strong) NSArray *allAttendees;

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshAttendees];
}

- (void)refreshAttendees {
    self.allAttendees = [self fetchAllAttendees];
    self.savedAttendees.text = [NSString stringWithFormat:@"%ld Saved Attendees", (long)self.allAttendees.count];
}

- (NSArray *)fetchAllAttendees {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Attendee"];
    return [managedObjectContext executeFetchRequest:request error:nil];
}

@end
