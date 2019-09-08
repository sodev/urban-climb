//
//  SDVBarcodeScannerViewController.h
//  Urban Climb
//
//  Created by Sean O'Connor on 6/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MTBBarcodeScanner.h>

@class UBCBarcodeScannerViewController;

@protocol UBCBarcodeScannerViewControllerDelegate <NSObject>

- (void)viewController:(UBCBarcodeScannerViewController *_Nullable)viewController finishedWithCode:(AVMetadataMachineReadableCodeObject *_Nonnull)code;

@end

@interface UBCBarcodeScannerViewController : UIViewController

@property (nullable, weak) id <UBCBarcodeScannerViewControllerDelegate> delegate;

@end
