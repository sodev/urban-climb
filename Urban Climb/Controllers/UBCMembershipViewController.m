//
//  UBCMembershipViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCMembershipViewController.h"

#import "UBCUserService.h"

@interface UBCMembershipViewController ()

@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;

@end

@implementation UBCMembershipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.barcodeLabel.text = self.currentUser.barcode;
    self.barcodeImageView.image = [self barcodeFromString:self.currentUser.barcode];
    
    self.cardView.layer.shadowRadius  = 4.0;
    self.cardView.layer.shadowColor   = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
    self.cardView.layer.shadowOffset  = CGSizeMake(0.0, 2.0);
    self.cardView.layer.shadowOpacity = 0.5;;
    self.cardView.layer.cornerRadius = 10.0;
    self.cardView.layer.masksToBounds = NO;
}

- (UIImage *)barcodeFromString:(NSString *)barcode
{
    NSData *barcodeDate = [barcode dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:barcodeDate forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    return [UIImage imageWithCIImage:outputImage];
}

#pragma mark - IBActions

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)removeMembership:(id)sender
{
    UBCUserService *userService = [[UBCUserService alloc] init];
    [userService removeUser:self.currentUser];
    [self.delegate membershipRemovedByViewController:self];
}


@end
