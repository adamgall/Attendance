//
//  NewAttendeeViewController.m
//  Attendance
//
//  Created by Adam Gall on 8/4/16.
//  Copyright © 2016 gallio. All rights reserved.
//

#import "AppDelegate.h"
#import "Attendee.h"
#import "NewAttendeeViewController.h"

@interface NewAttendeeViewController ()

@property (nonatomic, strong) IBOutlet UITextField *name;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *phone;
@property (nonatomic, strong) IBOutlet UIButton *submit;
@property (nonatomic, strong) IBOutlet UILabel *error;

@end

@implementation NewAttendeeViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.error.hidden = YES;
}

#pragma mark - Touch events

- (IBAction)didTapSubmit:(id)sender {
    if ([self isValidForm]) {
        [self saveNewAttendee];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private helpers

- (BOOL)isValidForm {
    BOOL isValidName = ![[self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    
    if (!isValidName) {
        self.error.text = @"Name cannot be blank";
    }
    
    self.error.hidden = isValidName;
    return isValidName;
}

- (void)saveNewAttendee {
    NSString *name = [self.name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.email.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *phone = [self.phone.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    Attendee *newAttendee = [NSEntityDescription insertNewObjectForEntityForName:@"Attendee" inManagedObjectContext:managedObjectContext];
    
    newAttendee.name = name;
    newAttendee.email = email;
    newAttendee.phone = phone;
    
    [managedObjectContext save:nil];
}

@end
