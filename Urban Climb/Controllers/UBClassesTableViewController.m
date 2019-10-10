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

#import "UBCClassTableViewCell.h"

@interface UBClassesTableViewController ()

@property (nonnull, strong) UBCClassTableDatasource *datasource;
@property (nonnull, strong) UBCClassService *classService;

@end

@implementation UBClassesTableViewController

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.datasource = [[UBCClassTableDatasource alloc] initWithStartDate:[NSDate now]];
    
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
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDatasource>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.datasource titleForSection:section];
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
