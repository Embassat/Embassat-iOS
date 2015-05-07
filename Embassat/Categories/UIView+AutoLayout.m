//
//  UIView+AutoLayout.m
//  YouBarcelona
//
//  Created by Joan Romano on 01/08/13.
//  Copyright (c) 2013 Crows And Dogs. All rights reserved.
//

#import "UIView+AutoLayout.h"

#import "NSLayoutConstraint+ConstraintMatching.h"

CGFloat const CADAutolayoutStandardFixedViewToViewSpace = 8.0f;
CGFloat const CADAutolayoutStandardFixedViewToSuperviewSpace = 20.0f;

@implementation UIView (AutoLayout)

#pragma mark - Constructors

+ (instancetype)newAutolayoutView
{
    UIView *view = [self new];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    return view;
}

#pragma mark - Size constraining

- (void)constrainToSize:(CGSize)size
{
    [self constrainToWidth:size.width];
    [self constrainToHeight:size.height];
}

- (void)constrainToWidth:(CGFloat)width
{
    NSString *formatString = @"H:[view(==width)]";
    NSDictionary *bindings = @{@"view": self};
    NSDictionary *metrics = @{@"width":@(width)};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString options:0 metrics:metrics views:bindings];
    
    [self addConstraints:constraints];
}

- (void)constrainToHeight:(CGFloat)height
{
    NSString *formatString = @"V:[view(==height)]";
    NSDictionary *bindings = @{@"view": self};
    NSDictionary *metrics = @{@"height":@(height)};
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:formatString options:0 metrics:metrics views:bindings];
    
    [self addConstraints:constraints];
}

#pragma mark - Align in superview constraining

- (void)alignLeftInSuperview
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1.0f constant:0.0f]];
}

- (void)alignRightInSuperview
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1.0f constant:0.0f]];
}

- (void)centerXOfSubview:(UIView *)firstSubview withSubview:(UIView *)secondSubview
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstSubview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:secondSubview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
}

- (void)centerYOfSubview:(UIView *)firstSubview withSubview:(UIView *)secondSubview
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:firstSubview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:secondSubview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

#pragma mark - Fill in superview constraining

- (void)fillInSuperview
{
    [self horizontallyFillInSuperview];
    [self verticallyFillInSuperview];
}

- (void)verticallyFillInSuperview
{
    [self.superview fillViewGroup:@[self] withDirection:UIViewLayoutDirectionVertical];
}

- (void)horizontallyFillInSuperview
{
    [self.superview fillViewGroup:@[self] withDirection:UIViewLayoutDirectionHorizontal];
}

- (void)fillViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction
{
    [self fillViewGroup:views withDirection:direction options:0];
}

- (void)fillViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction options:(NSLayoutFormatOptions)options
{
    if (![views count])
        return;
    
    NSMutableString *mutableConstraint = [[NSString stringWithFormat:@"%@:|",
                                           direction == UIViewLayoutDirectionHorizontal ? @"H" : @"V"] mutableCopy];
    NSMutableDictionary *viewsMutableDictionary = [NSMutableDictionary dictionary];
    
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        unsigned long index = (unsigned long) idx;
        
        NSString *viewConstraintString = index == 0 ? [NSString stringWithFormat:@"[view%lu]", index] :
                                                    [NSString stringWithFormat:@"-[view%lu]", index],
                 *viewKeyString = [NSString stringWithFormat:@"view%lu", index];
        
        [mutableConstraint appendString:viewConstraintString];
        [viewsMutableDictionary setObject:view forKey:viewKeyString];
    }];
    
    [mutableConstraint appendString:@"|"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[mutableConstraint copy] options:options metrics:nil views:[viewsMutableDictionary copy]]];
}

#pragma mark - Center in superview constraining

- (void)centerInSuperview
{
    [self centerXInSuperview];
    [self centerYInSuperview];
}

- (void)centerXInSuperview
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0f
                                                                constant:0.0f]];
}

- (void)centerYInSuperview
{
    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.superview
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0f
                                                                constant:0.0f]];
}

- (void)centerViewGroup:(NSArray *)views
{
    [self centerViewGroupInX:views];
    [self centerViewGroupInY:views];
}

- (void)centerViewGroupInX:(NSArray *)views
{
    [self centerViewGroupInX:views withFixedSpace:CADAutolayoutStandardFixedViewToViewSpace];
}

- (void)centerViewGroupInX:(NSArray *)views withFixedSpace:(CGFloat)space
{
    [self centerViewGroupInX:views withFixedSpace:space options:0];
}

- (void)centerViewGroupInX:(NSArray *)views withFixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options
{
    [self centerViewGroup:views withDirection:UIViewLayoutDirectionHorizontal fixedSpace:space options:options];
}

- (void)centerViewGroupInY:(NSArray *)views
{
    [self centerViewGroupInY:views withFixedSpace:CADAutolayoutStandardFixedViewToViewSpace];
}

- (void)centerViewGroupInY:(NSArray *)views withFixedSpace:(CGFloat)space
{
    [self centerViewGroupInY:views withFixedSpace:space options:0];
}

- (void)centerViewGroupInY:(NSArray *)views withFixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options
{
    [self centerViewGroup:views withDirection:UIViewLayoutDirectionVertical fixedSpace:space options:options];
}

- (void)centerViewGroup:(NSArray *)views withDirection:(UIViewLayoutDirection)direction fixedSpace:(CGFloat)space options:(NSLayoutFormatOptions)options
{
    if (![views count])
        return;
    
    NSMutableString *mutableConstraint = [[NSString stringWithFormat:@"%@:|[topSpacer(==bottomSpacer)]", direction == UIViewLayoutDirectionHorizontal ? @"H" : @"V"] mutableCopy];
    UIView *topSpacer, *bottomSpacer;
    NSDictionary *metrics = @{@"space":@(space)};
    NSMutableDictionary *viewsMutableDictionary = [NSMutableDictionary dictionary];
    
    topSpacer = [UIView newAutolayoutView];
    bottomSpacer = [UIView newAutolayoutView];
    
    [self insertSubview:topSpacer aboveSubview:views[0]];
    [self insertSubview:bottomSpacer belowSubview:[views lastObject]];
    
    [viewsMutableDictionary setObject:topSpacer forKey:@"topSpacer"];
    [viewsMutableDictionary setObject:bottomSpacer forKey:@"bottomSpacer"];
    
    [views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        
        unsigned long index = (unsigned long) idx;
        
        NSString *viewConstraintString = index == 0 ? [NSString stringWithFormat:@"[view%lu]", index]
        : [NSString stringWithFormat:@"-space-[view%lu]", index],
        *viewKeyString = [NSString stringWithFormat:@"view%lu", index];
        [mutableConstraint appendString:viewConstraintString];
        [viewsMutableDictionary setObject:view forKey:viewKeyString];
    }];
    
    [mutableConstraint appendString:@"[bottomSpacer]|"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[mutableConstraint copy] options:options metrics:metrics views:[viewsMutableDictionary copy]]];
}

#pragma mark - Retrieving

- (NSArray *)constraintsReferencingView:(UIView *)theView
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *views = [@[self] arrayByAddingObjectsFromArray:self.superviews];
    
    for (UIView *view in views)
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if (![constraint.class isEqual:[NSLayoutConstraint class]])
                continue;
            
            if ([constraint refersToView:theView])
                [array addObject:constraint];
        }
    
    return array;
}

- (NSArray *)superviews
{
    NSMutableArray *array = [NSMutableArray array];
    UIView *view = self.superview;
    while (view)
    {
        [array addObject:view];
        view = view.superview;
    }
    
    return array;
}


- (NSArray *)constraintsReferencingView:(UIView *)firstView andView:(UIView *)secondView
{
    NSArray *firstArray = [self constraintsReferencingView:firstView];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in firstArray)
    {
        if ([constraint refersToView:secondView])
            [array addObject:constraint];
    }
    
    return array;
}

- (NSArray *)IBSourcedConstraintsReferencingView:(UIView *)theView
{
    NSMutableArray *results = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in [self constraintsReferencingView:theView])
    {
        if (constraint.shouldBeArchived)
            [results addObject:constraint];
    }
    
    return results;
}

@end
