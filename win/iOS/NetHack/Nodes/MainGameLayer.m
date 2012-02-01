//
//  MainGameLayer.m
//  NetHack
//
//  Created by Dirk Zimmermann on 2/1/12.
//  Copyright 2012 Dirk Zimmermann. All rights reserved.
//

#include <sys/stat.h> // mkdir()

#import "MainGameLayer.h"

#import "GlobalConfig.h"
#import "RoguelikeTextView.h"

#import "NHYNQuestion.h"

extern int unix_main(int argc, char **argv);

@interface MainGameLayer () {
    
    NSThread *netHackThread;
    RoguelikeTextView *dummyTextView;
    NSString *messageFontFileName;
    
}

@property (nonatomic, retain) NHYNQuestion *currentYNQuestion;
@property (nonatomic, readonly) NSMutableArray *messageLabels;

- (void)netHackMainLoop:(id)arg;
- (void)putString:(NSString *)line;

@end

@implementation MainGameLayer

@synthesize currentYNQuestion;
@synthesize messageLabels;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *layer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        messageFontFileName = @"MessageFont.fnt";
		
		// create and initialize a Label
		CCLabelBMFont *label = [CCLabelBMFont labelWithString:@"MainGameLayer" fntFile:messageFontFileName];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
        
        dummyTextView = [[RoguelikeTextView alloc] initWithFrame:CGRectZero];
        [[[CCDirector sharedDirector] openGLView] addSubview:dummyTextView];
        dummyTextView.delegate = self;
        [dummyTextView release];
        
        [[GlobalConfig sharedInstance] setObject:self forKey:kNHHandler];

        netHackThread = [[NSThread alloc] initWithTarget:self selector:@selector(netHackMainLoop:) object:nil];
        [netHackThread start];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark - NetHack main loop

- (void)netHackMainLoop:(id)arg {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
#ifdef SLASHEM
	char *argv[] = {
		"SlashEM",
	};
#else
	char *argv[] = {
		"NetHack",
	};
#endif
	int argc = sizeof(argv)/sizeof(char *);
	
	// create necessary directories
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *baseDirectory = [paths objectAtIndex:0];
	DLog(@"baseDir %@", baseDirectory);
	setenv("NETHACKDIR", [baseDirectory cStringUsingEncoding:NSASCIIStringEncoding], 1);
	//setenv("SHOPTYPE", "G", 1); // force general stores on every level in wizard mode
	NSString *saveDirectory = [baseDirectory stringByAppendingPathComponent:@"save"];
	mkdir([saveDirectory cStringUsingEncoding:NSASCIIStringEncoding], 0777);
	
	// show directory (for debugging)
#if 0	
	for (NSString *filename in [[NSFileManager defaultManager] enumeratorAtPath:baseDirectory]) {
		DLog(@"%@", filename);
	}
#endif
	
	// call it
	unix_main(argc, argv);
	
	// clean up thread pool
	[pool drain];
}

#pragma mark - Util

- (void)putString:(NSString *)line {
    if (self.messageLabels.count > 0) {
        
    } else {
        
    }
}

#pragma mark - NHHandler

- (void)handleYNQuestion:(NHYNQuestion *)question {
    self.currentYNQuestion = question;
    [self putString:question.question];
}

- (void)handleMenuWindow:(NHMenuWindow *)w {
    
}

- (void)handleRawPrintWithMessageWindow:(NHMessageWindow *)w {
    
}

- (void)handleMessageWindow:(NHMessageWindow *)w shouldBlock:(BOOL)b {
    
}

- (void)handlePoskey:(NHPoskey *)p {
    
}

- (void)handleMapWindow:(NHMapWindow *)w shouldBlock:(BOOL)b {
    
}

- (void)handleStatusWindow:(NHStatusWindow *)w {
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (text.length == 1) {
        char c = [text characterAtIndex:0];
        if (self.currentYNQuestion) {
            currentYNQuestion.choice = c;
            [currentYNQuestion signal];
            self.currentYNQuestion = nil;
        }
    }
    return NO;
}

#pragma mark - Properties

- (NSMutableArray *)messageLabels {
    if (!messageLabels) {
        messageLabels = [[NSMutableArray alloc] init];
    }
    return messageLabels;
}

@end
