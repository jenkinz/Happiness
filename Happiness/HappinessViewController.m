//
//  HappinessViewController.m
//  Happiness
//
//  Created by Brian Jenkins on 9/7/12.
//  Copyright (c) 2012 Brian Jenkins. All rights reserved.
//

#import "HappinessViewController.h"
#import "HappinessFaceView.h"

@interface HappinessViewController ()

@property (nonatomic, weak) IBOutlet HappinessFaceView *faceView;

@end

@implementation HappinessViewController

@synthesize happiness = _happiness;
@synthesize faceView = _faceView;

- (void)setHappiness:(int)happiness
{
    _happiness = happiness;
    [self.faceView setNeedsDisplay]; // anytime `happiness` gets set, redraw the view
}

@end
