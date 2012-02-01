//
//  RoguelikeTextView.h
//  RogueTerm
//
//  Created by Dirk Zimmermann on 7/21/11.
//  Copyright 2011 Dirk Zimmermann. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { RoguelikeTextViewNone, RoguelikeTextViewControl, RoguelikeTextViewMeta }  RoguelikeTextViewControlKeyState;

@class RoguelikeTextView;

/**
 * Hidden dummy text view to give you a keyboard suitable for Roguelikes
 */
@interface RoguelikeTextView : UITextView {
    
    UIButton *controlButton;
    UIButton *metaButton;

}

@property (nonatomic, readonly) RoguelikeTextViewControlKeyState controlKeyState;

- (void)resetControlButtons;

@end
