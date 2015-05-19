//
//  CADEMScheduleHeaderView.m
//  Embassat
//
//  Created by Joan Romano on 20/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMScheduleHeaderView.h"

#import "UIColor+EMAdditions.h"

@interface CADEMScheduleHeaderView ()

@property (nonatomic, weak) IBOutlet UIView *thursdayContainer, *fridayContainer, *saturdayContainer;
@property (nonatomic, weak) IBOutlet UILabel *thursdayLabel, *fridayLabel, *saturdayLabel;

@property (nonatomic, strong) RACSubject *daySelectedSignal;

@end

@implementation CADEMScheduleHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.thursdayLabel.textColor = [UIColor whiteColor];
    self.thursdayContainer.backgroundColor = [UIColor em_scheduleHeaderBackgroundColor];
    self.daySelectedSignal = [RACSubject subject];
    
    [@[self.thursdayContainer, self.fridayContainer, self.saturdayContainer] enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerTapped:)];
        [subview addGestureRecognizer:tapGesture];
    }];
    
    self.thursdayLabel.font = self.fridayLabel.font = self.saturdayLabel.font = [UIFont em_detailFontOfSize:15.0f];
}

- (void)containerTapped:(UITapGestureRecognizer *)sender
{
    NSArray *containers = @[self.thursdayContainer, self.fridayContainer, self.saturdayContainer];
    
    [[containers.rac_sequence filter:^BOOL(UIView *view) {
        return view.tag == sender.view.tag;
    }].array enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        subview.backgroundColor = [UIColor em_scheduleHeaderBackgroundColor];
        ((UILabel *)[subview.subviews firstObject]).textColor = [UIColor whiteColor];
    }];
    
    [[containers.rac_sequence filter:^BOOL(UIView *view) {
        return view.tag != sender.view.tag;
    }].array enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        subview.backgroundColor = [UIColor em_scheduleHeaderDeselectedBackgroundColor];
        ((UILabel *)[subview.subviews firstObject]).textColor = [UIColor em_scheduleHeaderDeselectedTextColor];
    }];
    
    [(RACSubject *)self.daySelectedSignal sendNext:@(sender.view.tag)];
}

@end
