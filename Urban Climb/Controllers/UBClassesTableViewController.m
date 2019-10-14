//
//  UBClassesTableViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBClassesTableViewController.h"

#import "UBCClass.h"
#import "UBCClassTableDatasource.h"

#import "UBCClassService.h"
#import "UBCUserService.h"

#import "UBCClassTableViewCell.h"
#import "UBCClassSectionHeaderCell.h"

@interface UBClassesTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonnull, strong) UBCClassTableDatasource *datasource;
@property (nonnull, strong) UBCClassService *classService;
@property (nonnull, strong) UBCUserService *userService;

@end

@implementation UBClassesTableViewController

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.datasource = [[UBCClassTableDatasource alloc] initWithStartDate:[NSDate date]];
    self.userService = [[UBCUserService alloc] init];
    self.classService = [[UBCClassService alloc] init];
    [self.classService fetchClassesFromServer:^(NSError * _Nullable error) {
        if (error == nil) {
            self.datasource = [[UBCClassTableDatasource alloc] initWithStartDate:[NSDate date]];
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UBCUser *currentUser = self.userService.retrieveStoredUser;
    self.tableView.userInteractionEnabled = currentUser != NULL;
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDatasource>

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UBCClassSectionHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"UBCClassSectionHeaderCell"];
    
    NSString *title = [self.datasource titleForSection:section];
    [headerCell configureWithTitle:title];
    
    return headerCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datasource numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UBCClass *class = [self.datasource classForIndexPath:indexPath];
    
    UBCClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UBCClassTableViewCell" forIndexPath:indexPath];
    [cell configureWithClass:class];
    
    return cell;
}

#pragma mark <UITableViewDelegate> Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.datasource canSelectRowAtIndexPath:indexPath] == NO) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UBCClass *class = [self.datasource classForIndexPath:indexPath];
    
    NSString *message = [NSString stringWithFormat:@"%@ with %@ at %@ on %@", class.name, class.instructor, class.timeString, class.dateString];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm Booking"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.classService bookClass:class completion:^(NSError * _Nullable error) {
            
            NSString *title;
            NSString *message;
            if (error == nil) {
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                class.isBooked = YES;
                [realm commitWriteTransaction];
                [self.tableView reloadData];
                
                title = @"Booking confirmed";
                message = @"";
            } else {
                title = @"Unable to complete booking";
                message = error.localizedDescription;
            }
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                message:message
                                                                            preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:NULL]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:NULL]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
