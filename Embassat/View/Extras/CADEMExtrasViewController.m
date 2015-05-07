//
//  CADEMExtrasViewController.m
//  Embassa't
//
//  Created by Joan Romano on 11/06/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMExtrasViewController.h"

@interface CADEMExtrasViewController ()

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *bodyLabels;

@end

@implementation CADEMExtrasViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"EXTRES";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont em_boldFontOfSize:16.0];
    }];
    [self.bodyLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont em_romanFontOfSize:16.0];
    }];
}

@end
