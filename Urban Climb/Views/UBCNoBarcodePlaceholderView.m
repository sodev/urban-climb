//
//  UPTNoBarcodePlaceholderView.m
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCNoBarcodePlaceholderView.h"

@implementation UBCNoBarcodePlaceholderView

- (IBAction)addBarcode:(id)sender
{
    [self.delegate addBarcodeButtonTapped];
}


@end
