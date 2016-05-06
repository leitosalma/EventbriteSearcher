//
//  EVSEventDetail.m
//  EventbriteSearcher
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

#import "EVSEventDetailViewController.h"

@interface EVSEventDetailViewController()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation EVSEventDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadHTMLString:self.detail baseURL:nil];
}

@end
