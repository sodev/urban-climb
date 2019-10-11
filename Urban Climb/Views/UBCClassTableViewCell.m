//
//  UBCClassTableViewCell.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassTableViewCell.h"

@interface UBCClassTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *classTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookedLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullLabel;

@end

@implementation UBCClassTableViewCell

- (void)configureWithClass:(UBCClass *)classObject
{
    NSDictionary *classIconMapping = @{
        @"Yoga": @"yogaIcon",
        @"Fitness": @"fitnessIcon",
        @"Climbing": @"climbingIcon",
        
    };
    
    NSString *imageName = classIconMapping[classObject.type];
    if (imageName != nil) {
        self.classTypeImageView.image = [UIImage imageNamed:imageName];
    }
    
    self.instructorLabel.text = classObject.instructor;
    self.classNameLabel.text = classObject.name;
    self.classTimeLabel.text = classObject.timeString;
    self.bookedLabel.hidden = classObject.isBooked == NO;
    self.fullLabel.hidden = classObject.isFull == NO;
    
    if (classObject.isBooked) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.05];
    } else if (classObject.isFull) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.05];
    } else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
