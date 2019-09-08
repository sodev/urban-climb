//
//  ViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 11/8/18.
//  Copyright © 2018 Sodev. All rights reserved.
//



#import "UBCHomeViewController.h"
#import "UBCBarcodeScannerViewController.h"

#import "UBCUserService.h"

#import "UBCUser.h"

#import "UBCNoBarcodePlaceholderView.h"
#import "UBCBarcodeView.h"

static NSString * const ADD_BARCODE_SEGUE_IDENTIFIER = @"BarcodeScannerSegue";

@interface UBCHomeViewController () <UBCBarcodeScannerViewControllerDelegate, UBCNoBarcodePlaceholderViewDelegate>

@property (nonatomic, strong, nullable) UBCUser *currentUser;
@property (nonatomic, strong, nonnull) UBCUserService *userService;

@end

@implementation UBCHomeViewController

- (void)loadView
{
    [super loadView];
    
    self.userService = [[UBCUserService alloc] init];
    self.currentUser = [self.userService retrieveStoredUser];
    
    [self updateView];
}

- (void)updateView
{
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.currentUser == NULL) {
        UBCNoBarcodePlaceholderView *placeholderView = [[[NSBundle mainBundle] loadNibNamed:@"UBCNoBarcodePlaceholderView" owner:self options:nil] firstObject];
        placeholderView.delegate = self;
        placeholderView.frame = self.view.frame;
        [self.view addSubview:placeholderView];
    } else {
        UBCBarcodeView *barcodeView = [[[NSBundle mainBundle] loadNibNamed:@"UBCBarcodeView" owner:self options:nil] firstObject];
        [barcodeView configureWithBarcode:self.currentUser.barcode];
        barcodeView.frame = self.view.frame;
        [self.view addSubview:barcodeView];
    }
}

#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ADD_BARCODE_SEGUE_IDENTIFIER]) {
        UBCBarcodeScannerViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.delegate = self;
    }
}

#pragma mark - <UBCNoBarcodePlaceholderViewDelegate> methods

- (void)addBarcodeButtonTapped
{
    [self performSegueWithIdentifier:ADD_BARCODE_SEGUE_IDENTIFIER sender:nil];
}

#pragma mark - <UBCBarcodeScannerViewControllerDelegate> Methods

- (void)viewController:(UBCBarcodeScannerViewController *)viewController finishedWithCode:(AVMetadataMachineReadableCodeObject *)code
{
    [self dismissViewControllerAnimated:viewController completion:NULL];
    
    self.currentUser = [[UBCUser alloc] initWithBarcode:code.stringValue];
    [self.userService storeUser:self.currentUser];
    
    [self updateView];
}

@end
