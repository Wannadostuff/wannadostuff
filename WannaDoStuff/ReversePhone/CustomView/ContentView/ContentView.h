//
//  ContentView.h
//  PrivateText
//
//  Created by Mac on 3/29/16.
//  Copyright © 2016 returnzero. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface ContentView : UIView

@property (nonatomic, strong) UITextView *chatTextView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic, assign) CGFloat initialHeight;
@property (nonatomic, assign) CGFloat maximumHeight;
@property (nonatomic, assign) NSInteger maximumNumberOfLines;
@property (nonatomic, assign) NSInteger minimumNumberOfLines;
@property (nonatomic, strong) NSLayoutConstraint *chatTextViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *contentViewHeightConstraint;

-(id)initWithTextView:(UITextView *)textView ChatTextViewHeightConstraint:(NSLayoutConstraint *)heightConstraint contentView:(UIView *)contentView ContentViewHeightConstraint:(NSLayoutConstraint *)contentViewHeightConstraint andContentViewBottomConstraint:(NSLayoutConstraint *)contentViewBottomConstraint;

- (void)updateMinimumNumberOfLines:(NSInteger)minimumNumberOfLines
            andMaximumNumberOfLine:(NSInteger)maximumNumberOfLines;

- (void)resizeTextViewWithAnimation:(BOOL)animated;
-(void)textViewDidChange:(UITextView *)textView;

@end

