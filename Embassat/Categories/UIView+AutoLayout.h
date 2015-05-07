//
//  UIView+AutoLayout.h
//  YouBarcelona
//
//  Created by Joan Romano on 01/08/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

extern CGFloat const CADAutolayoutStandardFixedViewToViewSpace;
extern CGFloat const CADAutolayoutStandardFixedViewToSuperviewSpace;

typedef NS_ENUM(NSUInteger, UIViewLayoutDirection){
    UIViewLayoutDirectionHorizontal,
    UIViewLayoutDirectionVertical
};

@interface UIView (AutoLayout)

+ (instancetype)newAutolayoutView;

- (void)constrainToSize:(CGSize)size;
- (void)constrainToWidth:(CGFloat)width;
- (void)constrainToHeight:(CGFloat)height;

- (void)centerInSuperview;
- (void)centerXInSuperview;
- (void)centerYInSuperview;

- (void)fillInSuperview;
- (void)verticallyFillInSuperview;
- (void)horizontallyFillInSuperview;

- (void)fillViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction;
- (void)fillViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction options:(NSLayoutFormatOptions)options;

- (void)alignLeftInSuperview;
- (void)alignRightInSuperview;

- (void)centerXOfSubview:(UIView *)firstSubview withSubview:(UIView *)secondSubview;
- (void)centerYOfSubview:(UIView *)firstSubview withSubview:(UIView *)secondSubview;

- (void)centerViewGroup:(NSArray *)views;
- (void)centerViewGroupInX:(NSArray *)views;
- (void)centerViewGroupInY:(NSArray *)views;
- (void)centerViewGroupInX:(NSArray *)views withFixedSpace:(CGFloat)space;
- (void)centerViewGroupInY:(NSArray *)views withFixedSpace:(CGFloat)space;
- (void)centerViewGroupInX:(NSArray *)views withFixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options;
- (void)centerViewGroupInY:(NSArray *)views withFixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options;
- (void)centerViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction fixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options;

- (NSArray *)constraintsReferencingView:(UIView *)firstView andView:(UIView *)secondView;
- (NSArray *) IBSourcedConstraintsReferencingView:(UIView *)theView;

@end
