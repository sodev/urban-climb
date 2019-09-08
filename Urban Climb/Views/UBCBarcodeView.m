//
//  UPTBarcodeView.m
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "UBCBarcodeView.h"

@interface UBCBarcodeView ()

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;

@end

@implementation UBCBarcodeView

- (void)configureWithBarcode:(NSString *)barcode
{
    self.barcodeLabel.text = barcode;
    self.barcodeImageView.image = [self barcodeFromString:barcode];
    
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
