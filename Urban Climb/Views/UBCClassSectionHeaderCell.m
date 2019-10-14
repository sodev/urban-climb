//
//  UBCClassSectionHeaderCell.m
//  Urban Climb
//
//  Created by Sean O'Connor on 14/10/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassSectionHeaderCell.h"

@interface UBCClassSectionHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UBCClassSectionHeaderCell

- (void)configureWithTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
