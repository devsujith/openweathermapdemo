//
//  TableViewCell.h
//  testwetherapp
//
//  Created by administrator on 31/12/2014.
//  Copyright (c) 2014 Sujith Chandran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressurLabel;
@property (weak, nonatomic) IBOutlet UIView *notfoundview;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;



@end
