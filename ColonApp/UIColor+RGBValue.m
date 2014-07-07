//
//  UIColor+RGBValue.m
//  ColonApp
//
//  Created by Manuel Ruiz on 7/4/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import "UIColor+RGBValue.h"

@implementation UIColor (RGBValue)

+ (UIColor *)RGBValueRed:(CGFloat)red Green:(CGFloat)green andBlue:(CGFloat)blue{
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:1.0];
}

+ (UIColor *) darkGreyColorForCell{
    return [UIColor RGBValueRed:27.0 Green:27.0 andBlue:26.0];
}


+ (UIColor *) blackColorForCell{
    return [UIColor RGBValueRed:15.0 Green:15.0 andBlue:15.0];
}

@end
