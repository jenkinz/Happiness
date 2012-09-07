//
//  HappinessFaceView.m
//  Happiness
//
//  Created by Brian Jenkins on 9/7/12.
//  Copyright (c) 2012 Brian Jenkins. All rights reserved.
//

#import "HappinessFaceView.h"

@implementation HappinessFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawCircleAtPoint:(CGPoint)p withRadius:(CGFloat)radius inContext:(CGContextRef)context // subroutine for drawing a circle
{
    UIGraphicsPushContext(context); // in subroutines, always push the context before playing with it
    
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x, p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    
    UIGraphicsPopContext(); // in subroutines, always pop the context when done with it
}

#define DEFAULT_SCALE 0.90
#define EYE_H 0.35 // the eye constants are in percentages of the size of the face
#define EYE_V 0.35
#define EYE_RADIUS 0.10

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext(); // always get current context at the beginning of drawRect - we need this context for any of the core graphics functions
    
    // draw face (circle)
    
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size; // set radius to half of the min of the height & width of the view
    if (self.bounds.size.height < self.bounds.size.width) {
        size = self.bounds.size.height/2;
    }
    else {
        size = self.bounds.size.width/2;
    }
    size *= DEFAULT_SCALE; // scale it so it doesn't go right to the edges
    
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor] setStroke];
    
    [self drawCircleAtPoint:midPoint withRadius:size inContext:context];
    
    // draw eyes (2 circles)
    
    CGPoint eyePoint;
    eyePoint.x = midPoint.x - size * EYE_H;
    eyePoint.y = midPoint.y - size * EYE_V;
    
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    eyePoint.x += size * EYE_H * 2;
    [self drawCircleAtPoint:eyePoint withRadius:size * EYE_RADIUS inContext:context];
    
    // no nose
    // draw mouth
    
    
}

@end
