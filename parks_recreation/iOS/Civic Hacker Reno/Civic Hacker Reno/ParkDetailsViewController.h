//
//  ParkDetailsViewController.h
//  Parks
//
//  Created by Haifisch on 6/2/14.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkDetailsViewController : UITableViewController{
}
@property (strong) NSString *parkName;
@property double latitude;
@property double longitude;

@end
