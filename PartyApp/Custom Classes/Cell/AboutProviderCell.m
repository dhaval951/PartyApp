//
//  AboutProviderCell.m
//  PartyApp
//
//  Created by Admin on 12/24/17.
//  Copyright © 2017 Vijay King. All rights reserved.
//

#import "AboutProviderCell.h"
#import "ResponsiveLabel.h"
#import "AppConstants.h"
#import "NSAttributedString+Processing.h"


static NSString *kExpansionToken = @"...Read More";
static NSString *kCollapseToken = @"Read Less";

@implementation AboutProviderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lblAbout.textColor = RGBCOLOR(65, 65, 65);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:kExpansionToken];
    
    PatternTapResponder tapAction = ^(NSString *tappedString) {

//        [self configureText:self.lblAbout.text forExpandedState:YES];
        if (_delegate) {
            [_delegate cell:self isExpanded:true];
        }
    };
    
    [attributedString addAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 167, 157),
                                      NSFontAttributeName:self.lblAbout.font,
                                      RLTapResponderAttributeName:tapAction}
                              range:NSMakeRange(0, kExpansionToken.length)];
    [self.lblAbout setAttributedTruncationToken:attributedString];
    self.lblAbout.userInteractionEnabled = YES;
    NSString *textstr = @"text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text text ";
    textstr = @"text text text text text text text text text text text text text text text text ";
//    [self configureText:textstr forExpandedState:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureText:(NSString*)str forExpandedState:(BOOL)isExpanded {
    NSMutableAttributedString *finalString;
    if (isExpanded) {
        NSString *expandedString = [NSString stringWithFormat:@"%@%@",str,kCollapseToken];
        finalString = [[NSMutableAttributedString alloc]initWithString:expandedString attributes:@{NSForegroundColorAttributeName:RGBCOLOR(65, 65, 65)}];
        PatternTapResponder tap = ^(NSString *string) {
            if (_delegate) {
                [_delegate cell:self isExpanded:false];
            }
        };
        [finalString addAttributes:@{NSForegroundColorAttributeName:RGBCOLOR(0, 167, 157),RLTapResponderAttributeName:tap}
                             range:[expandedString rangeOfString:kCollapseToken]];
        [finalString addAttributes:@{NSFontAttributeName:self.lblAbout.font} range:NSMakeRange(0, finalString.length)];
        self.lblAbout.numberOfLines = 0;
        [self.lblAbout setAttributedText:finalString withTruncation:NO];
    }else {
        self.lblAbout.numberOfLines = 4;
        [self.lblAbout setText:str withTruncation:YES];
    }
}

@end
