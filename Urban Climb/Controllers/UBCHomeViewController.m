//
//  ViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 11/8/18.
//  Copyright © 2018 Sodev. All rights reserved.
//



#import "UBCHomeViewController.h"
#import "UBCBarcodeScannerViewController.h"
#import "UBCMembershipViewController.h"

#import "UBCUserService.h"

#import "UBCUser.h"

#import "UBCMembershipCardView.h"

static NSString * const ADD_BARCODE_SEGUE_IDENTIFIER = @"BarcodeScannerSegue";
static NSString * const EDIT_MEMBERSHIP_SEGUE_IDENTIFIER = @"EditMembershipSegue";

@interface UBCHomeViewController () <UBCBarcodeScannerViewControllerDelegate, UBCMembershipCardViewDelegate>

@property (nonatomic, strong, nullable) UBCUser *currentUser;
@property (nonatomic, strong, nonnull) UBCUserService *userService;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (nonnull, nonatomic) UBCMembershipCardView *cardView;

@end

@implementation UBCHomeViewController

- (void)loadView
{
    [super loadView];
    
    self.userService = [[UBCUserService alloc] init];
    
    self.cardView = [[NSBundle mainBundle] loadNibNamed:@"UBCMembershipCardView" owner:nil options:nil].lastObject;
    self.cardView.delegate = self;
    [self.view addSubview:self.cardView];
    
//    [self.cardView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:0.0].active = YES;
//    [self.cardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0.0].active = YES;
//    [self.cardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0.0].active = YES;
//    [self.cardView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0.0].active = YES;
    self.cardView.frame = CGRectMake(16, 132, self.view.frame.size.width - 32, 550);
    
    self.cardView.layer.shadowRadius  = 4.0;
    self.cardView.layer.shadowColor   = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    self.cardView.layer.shadowOffset  = CGSizeMake(0.0, 2.0);
    self.cardView.layer.shadowOpacity = 0.5;;
    self.cardView.layer.cornerRadius = 10.0;
    self.cardView.layer.masksToBounds = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.currentUser = [self.userService retrieveStoredUser];
    
    [self updateContent];
}

- (void)updateContent
{
    if (self.currentUser == NULL) {
        [self.cardView configureWithPlaceholders];
        self.editButton.hidden = TRUE;
    } else {
        [self.cardView configureWithBarcode:self.currentUser.barcode];
        self.editButton.hidden = FALSE;
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_BARCODE_SEGUE_IDENTIFIER]) {
        UBCBarcodeScannerViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:EDIT_MEMBERSHIP_SEGUE_IDENTIFIER]) {
        UBCMembershipViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.currentUser = self.currentUser;
    }
}

#pragma mark - <UBCMembershipCardViewDelegate> methods

- (void)addBarcodeButtonTapped
{
    [self performSegueWithIdentifier:ADD_BARCODE_SEGUE_IDENTIFIER sender:nil];
}

#pragma mark - <UBCBarcodeScannerViewControllerDelegate> Methods

- (void)viewController:(UBCBarcodeScannerViewController *)viewController finishedWithCode:(AVMetadataMachineReadableCodeObject *)code
{
    [self dismissViewControllerAnimated:viewController completion:NULL];
    
    NSString *barcode = code.stringValue;
    UBCUser *currentUser = [[UBCUser alloc] initWithBarcode:barcode];
    [self.userService storeUser:currentUser];
    

    self.currentUser = self.userService.retrieveStoredUser;
    
    [self updateContent];
}

@end
