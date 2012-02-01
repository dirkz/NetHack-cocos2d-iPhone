//
//  RoguelikeTextView.m
//  RogueTerm
//
//  Created by Dirk Zimmermann on 7/21/11.
//  Copyright 2011 Dirk Zimmermann. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RoguelikeTextView.h"

@interface RoguelikeTextView ()

@property (nonatomic, readonly) UIView *inputAccessoryView;

- (UIButton *)createInputAccessoryViewButton;
- (void)highlightControlButton:(UIButton *)button;
- (void)handleInputAccessoryViewDoneButton:(id)sender;
- (void)handleInputAccessoryViewKeyButton:(UIButton *)sender;

@end

@implementation RoguelikeTextView

@synthesize inputAccessoryView;
@synthesize controlKeyState;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.keyboardType = UIKeyboardTypeASCIICapable;
        self.returnKeyType = UIReturnKeyDefault;
        self.inputAccessoryView = self.inputAccessoryView;
        [self.inputAccessoryView release];
    }
    return self;
}

- (id)inputAccessoryViewButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [[button layer] setCornerRadius:4.f];
    [[button layer] setMasksToBounds:YES];
    [[button layer] setBorderWidth:1.f];
    [[button layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.shadowOffset = CGSizeMake(0.f, -1.f);
    return button;
}

#pragma mark - Properties

- (UIView *)inputAccessoryView {
    if (!inputAccessoryView) {
        CGFloat buttonWidth = 90;
        CGFloat buttonHeight = 30;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            buttonHeight = 45;
        }
        CGFloat buttonGap = 5;
        inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.bounds.size.width, buttonHeight)];
        
        CGRect lastFrame;
        UIButton *doneButton = [self createInputAccessoryViewButton];
        doneButton.frame = CGRectMake(self.bounds.size.width - buttonWidth, 0.f, buttonWidth, buttonHeight);
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(handleInputAccessoryViewDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:doneButton];
        lastFrame = doneButton.frame;
        
        UIButton *escButton = [self createInputAccessoryViewButton];
        escButton.frame = CGRectMake(lastFrame.origin.x - buttonWidth - buttonGap, 0.f, buttonWidth, buttonHeight);
        escButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        escButton.tag = 033;
        [escButton setTitle:@"ESC" forState:UIControlStateNormal];
        [escButton addTarget:self action:@selector(handleInputAccessoryViewKeyButton:) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:escButton];
        
        controlButton = [self createInputAccessoryViewButton];
        controlButton.frame = CGRectMake(escButton.frame.origin.x - buttonWidth - buttonGap, 0.f, buttonWidth, buttonHeight);
        controlButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [controlButton setTitle:@"Ctrl" forState:UIControlStateNormal];
        [controlButton addTarget:self action:@selector(highlightControlButton:) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:controlButton];
        
        metaButton = [self createInputAccessoryViewButton];
        metaButton.frame = CGRectMake(controlButton.frame.origin.x - buttonWidth - buttonGap, 0.f, buttonWidth, buttonHeight);
        metaButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [metaButton setTitle:@"Meta" forState:UIControlStateNormal];
        [metaButton addTarget:self action:@selector(highlightControlButton:) forControlEvents:UIControlEventTouchUpInside];
        [inputAccessoryView addSubview:metaButton];
    }
    return inputAccessoryView;
}

#pragma mark - API

- (void)resetControlButtons {
    if (self.controlKeyState != RoguelikeTextViewNone) {
        controlKeyState = RoguelikeTextViewNone;
        metaButton.backgroundColor = nil;
        controlButton.backgroundColor = nil;
    }
}

#pragma mark - Util

- (UIButton *)createInputAccessoryViewButton {
    UIButton *button = [self inputAccessoryViewButton];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (void)highlightControlButton:(UIButton *)button {
    if (button == controlButton) {
        if (controlKeyState == RoguelikeTextViewControl) {
            button.backgroundColor = nil;
            controlKeyState = RoguelikeTextViewNone;
        } else {
            controlKeyState = RoguelikeTextViewControl;
            metaButton.backgroundColor = nil;
            button.backgroundColor = [UIColor blueColor];
        }
    } else if (button == metaButton) {
        if (controlKeyState == RoguelikeTextViewMeta) {
            button.backgroundColor = nil;
            controlKeyState = RoguelikeTextViewNone;
        } else {
            controlKeyState = RoguelikeTextViewMeta;
            controlButton.backgroundColor = nil;
            button.backgroundColor = [UIColor blueColor];
        }
    }
}

#pragma mark - Actions

- (void)handleInputAccessoryViewKeyButton:(UIButton *)sender {
    NSString *string = [NSString stringWithFormat:@"%c", sender.tag];
    [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, self.text.length) replacementText:string];
    [self resetControlButtons];
}

- (void)handleInputAccessoryViewDoneButton:(id)sender {
    [self resignFirstResponder];
}

@end
