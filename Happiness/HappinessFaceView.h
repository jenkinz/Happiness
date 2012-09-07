//
//  HappinessFaceView.h
//  Happiness
//
//  Created by Brian Jenkins on 9/7/12.
//  Copyright (c) 2012 Brian Jenkins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HappinessFaceView : UIView

@property (nonatomic) CGFloat scale; // how "zoomed in" we are on the face

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
