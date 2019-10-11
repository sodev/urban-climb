//
//  UBCMembershipCardView.m
//  Urban Climb
//
//  Created by Sean O'Connor on 9/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCMembershipCardView.h"

@interface UBCMembershipCardView ()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBarcodeButton;

@end

@implementation UBCMembershipCardView

- (void)configureWithBarcode:(NSString *_Nonnull)barcode
{
    self.barcodeLabel.text = barcode;
    self.barcodeLabel.alpha = 1.0;
    self.barcodeImageView.image = [self barcodeFromString:barcode];
    self.barcodeImageView.alpha = 1.0;
    self.addBarcodeButton.hidden = YES;
}

- (void)configureWithPlaceholders
{
    self.barcodeLabel.text = @"no barcode set";
    self.barcodeLabel.alpha = 0.1;
    self.barcodeImageView.image = [self barcodeFromString:@"0000000"];
    self.barcodeImageView.alpha = 0.1;
    self.addBarcodeButton.hidden = NO;
    self.addBarcodeButton.layer.cornerRadius = 5.0;
}

- (IBAction)addBarcodeButtonTapped:(id)sender
{
    [self.delegate addBarcodeButtonTapped];
}

- (UIImage *)barcodeFromString:(NSString *)barcode
{
    NSData *barcodeDate = [barcode dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:barcodeDate forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    return [UIImage imageWithCIImage:outputImage];
}

@end
