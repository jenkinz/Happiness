//
//  HappinessFaceView.m
//  Happiness
//
//  Created by Brian Jenkins on 9/7/12.
//  Copyright (c) 2012 Brian Jenkins. All rights reserved.
//

#import "HappinessFaceView.h"

#define DEFAULT_SCALE 0.90 // the scale factor for the circle face

#define EYE_H 0.35 // the following constants are in percentages of the size of the face
#define EYE_V 0.35
#define EYE_RADIUS 0.10
#define MOUTH_H 0.45
#define MOUTH_V 0.40

#define MOUTH_SMILE 0.25 // curve

@implementation HappinessFaceView

@synthesize scale = _scale;

- (CGFloat)scale
{
    if (!_scale) { // scale of 0 means it hasn't been set yet; return the default
        return DEFAULT_SCALE;
    }
    else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (_scale != scale) {
        _scale = scale;
        [self setNeedsDisplay]; // causes a redraw - we want this whenever the scale changes
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale;
        gesture.scale = 1.0; // set so that we have an incremental (instead of a cumulative) scale
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // redraw when bounds of frame changes (e.g. device rotation)
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
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
    size *= self.scale; // scale it based on the current scale (either default, or set by the pinch handler)
    
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
    
    CGPoint mouthStart;
    mouthStart.x = midPoint.x - MOUTH_H * size;
    mouthStart.y = midPoint.y + MOUTH_V * size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x += MOUTH_H * size * 2;
    CGPoint mouthCP1 = mouthStart; // control point 1
    mouthCP1.x += MOUTH_H * size * 2/3;
    CGPoint mouthCP2 = mouthEnd; // control point 2
    mouthCP2.x -= MOUTH_H * size * 2/3;
    
    float smile = 1.0; // moves control points up or down (0 in the middle; 1.0 full smile; -1.0 full frown)
    
    CGFloat smileOffset = MOUTH_SMILE * size * smile;
    mouthCP1.y += smileOffset;
    mouthCP2.y += smileOffset;
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP2.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
    CGContextStrokePath(context);
}

@end
