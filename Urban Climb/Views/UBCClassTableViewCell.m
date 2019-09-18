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

@end

@implementation UBCClassTableViewCell

- (void)configureWithClass:(UBCClass *)classObject
{
    switch (classObject.type) {
        case kYogaClass:
            self.classTypeImageView.image = [UIImage imageNamed:@"yogaIcon"];
            break;
        
        case kFitnessClass:
            self.classTypeImageView.image = [UIImage imageNamed:@"fitnessIcon"];
            break;
            
        case kClimbingClass:
            self.classTypeImageView.image = [UIImage imageNamed:@"climbingIcon"];
            break;
            
        default:
            break;
    }
    
    self.instructorLabel.text = classObject.instructor;
    self.classNameLabel.text = classObject.name;
    self.classTimeLabel.text = classObject.time;
    
}

@end
