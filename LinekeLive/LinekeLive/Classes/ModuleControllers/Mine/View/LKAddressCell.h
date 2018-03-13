//
//  LKAddressCell.h
//  LinekeLive
//
//  Created by Original_TJ on 2018/2/27.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) NSDictionary *addressMode;

@end
