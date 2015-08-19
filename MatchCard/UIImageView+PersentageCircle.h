//
//  UIImageView+PersentageCircle.h
//  SBF See
//
//  Created by Ralph Schön on 09.02.14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (PersentageCircle)

- (UIImageView *)applyCircleWithPersentage:(int)persent andText:(NSString *)string andTintColor:(UIColor *)color;

@end

// used to calculate the degrees to radians in UIImageView+PersentageCircle.m
static inline double radians (double degrees) { return degrees * M_PI / 180; }

