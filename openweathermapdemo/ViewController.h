//
//  ViewController.h
//  testwetherapp
//
//  Created by Sujith Chandran on 12/22/14.
//  Copyright (c) 2014 Sujith Chandran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface ViewController : UIViewController<SwipeViewDataSource,SwipeViewDelegate>


@property (weak, nonatomic) IBOutlet SwipeView *swipeview;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;
@property (weak, nonatomic) IBOutlet UILabel *viewcityname;
@property (weak, nonatomic) IBOutlet UILabel *viewcountry;
@property (weak, nonatomic) IBOutlet UILabel *viewgeo;


@property (weak, nonatomic) IBOutlet UILabel *citynamelabel;
@property (weak, nonatomic) IBOutlet UIView *cityview;
- (IBAction)removecity:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *aboutapp;
- (IBAction)currentlocation:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end

