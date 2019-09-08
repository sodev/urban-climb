//
//  SDVBarcodeScannerViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 6/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCBarcodeScannerViewController.h"

@interface UBCBarcodeScannerViewController ()

@property (weak, nonatomic) IBOutlet UIView *scannerView;
@property (nonnull, strong) MTBBarcodeScanner *scanner;

@end

@implementation UBCBarcodeScannerViewController

- (void)loadView
{
    [super loadView];
    
    self.scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
        if (success) {
            
            NSError *error = nil;
            [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
                
                [self.scanner stopScanning];
                [self.delegate viewController:self finishedWithCode:codes.firstObject];
                
            } error:&error];
            
        } else {
            // The user denied access to the camera
        }
    }];
}

@end
