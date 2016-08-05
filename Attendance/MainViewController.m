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

- (IBAction)didTapExport:(id)sender {
    NSData *exportFileData = [self createExport];
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

- (NSData *)createExport {
    NSMutableString *writeString = [[NSMutableString alloc] init];
    
    [writeString appendString:@"Name, Email, Phone\n"];
    for (Attendee *attendee in self.allAttendees) {
        [writeString appendString:[NSString stringWithFormat:@"%@, %@, %@\n", attendee.name, attendee.email, attendee.phone]];
    }
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"export.csv"];
    
    [writeString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    return [NSData dataWithContentsOfFile:filePath];
}

@end
