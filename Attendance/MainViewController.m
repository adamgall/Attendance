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
#import <MessageUI/MessageUI.h>

@interface MainViewController () <MFMailComposeViewControllerDelegate>

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
    [self showEmail:exportFileData];
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

- (void)showEmail:(NSData *)fileData {
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:@"Wow Much Attendees!"];
    [mc setMessageBody:@"Much Lists" isHTML:NO];
    [mc addAttachmentData:fileData mimeType:@"text/csv" fileName:@"attendees.csv"];
    [self presentViewController:mc animated:YES completion:nil];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled: NSLog(@"Mail cancelled"); break;
        case MFMailComposeResultSaved: NSLog(@"Mail saved"); break;
        case MFMailComposeResultSent: NSLog(@"Mail sent"); break;
        case MFMailComposeResultFailed: NSLog(@"Mail sent failure: %@", [error localizedDescription]); break;
        default: break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [self maybeDeleteAttendees];
        }
    }];
}

- (void)maybeDeleteAttendees {
    UIAlertController *alert = [[UIAlertController alloc] init];
    alert.title = @"Delete Exported Attendees?";
    alert.message = @"Would you like to delete the attendees that were just exported?";
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self yeahDeleteAttendees];
    }];
    [alert addAction:noAction];
    [alert addAction:yesAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)yeahDeleteAttendees {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    for (Attendee *attendee in self.allAttendees) {
        [managedObjectContext deleteObject:attendee];
    }
    [managedObjectContext save:nil];
    [self refreshAttendees];
}

@end
