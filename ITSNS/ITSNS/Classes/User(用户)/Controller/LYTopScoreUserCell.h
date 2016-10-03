//
//  LYTopScoreUserCell.h
//  ITSNS
//
//  Created by Ivan on 16/1/22.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LYTopScoreUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (nonatomic, strong)BmobUser *user;
@end
