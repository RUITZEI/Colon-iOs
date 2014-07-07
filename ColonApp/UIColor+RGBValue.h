//
//  UIColor+RGBValue.h
//  ColonApp
//
//  Created by Manuel Ruiz on 7/4/14.
//  Copyright (c) 2014 Ruitzei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBValue)

+ (UIColor *) RGBValueRed:(CGFloat)red Green:(CGFloat)green andBlue:(CGFloat)blue;
+ (UIColor *) blackColorForCell;
+ (UIColor *) darkGreyColorForCell;


@end
