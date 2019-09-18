//
//  UBCFacebookFeedViewController.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <WebKit/WKWebView.h>

#import "UBCFacebookFeedViewController.h"

@interface UBCFacebookFeedViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation UBCFacebookFeedViewController

- (void)loadView
{
    [super loadView];
    
    NSURL *URL = [NSURL URLWithString:@"https://mobile.facebook.com/urbanclimbcollingwood/posts/"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:URL];
    
    [self.webView loadRequest:urlRequest];
}

@end
