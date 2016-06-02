//
//  EventCell.m
//  EventBriteSearch
//
//  Created by Robin Spinks on 02/06/2016.
//  Copyright © 2016 Robin Spinks. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureCell];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell {
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setAdjustsFontSizeToFitWidth:YES];
}

@end
