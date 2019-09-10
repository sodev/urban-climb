//
//  UBCMembershipCardView.h
//  Urban Climb
//
//  Created by Sean O'Connor on 9/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#include <UIKit/UIKit.h>

@protocol UBCMembershipCardViewDelegate <NSObject>

- (void)addBarcodeButtonTapped;

@end

@interface UBCMembershipCardView : UIView

- (void)configureWithBarcode:(NSString *_Nonnull)barcode;

- (void)configureWithPlaceholders;

@property (nullable, weak) id <UBCMembershipCardViewDelegate> delegate;

@end
