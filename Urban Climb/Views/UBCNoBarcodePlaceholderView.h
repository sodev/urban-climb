//
//  UPTNoBarcodePlaceholderView.h
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UBCNoBarcodePlaceholderViewDelegate <NSObject>

- (void)addBarcodeButtonTapped;

@end

@interface UBCNoBarcodePlaceholderView : UIView

@property (nullable, weak) id <UBCNoBarcodePlaceholderViewDelegate> delegate;

@end
