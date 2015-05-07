//
//  CADEMTicketsViewController.m
//  Embassat
//
//  Created by Joan Romano on 22/05/14.
//  Copyright (c) 2014 Crows And Dogs. All rights reserved.
//

#import "CADEMTicketsViewController.h"

@interface CADEMTicketsViewController ()

@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *bodyLabels;

@property (nonatomic, weak) IBOutlet UIView *seasonContainer, *dayTicketContainer, *hotelContainer, *tresCContainer;

@end

@implementation CADEMTicketsViewController

- (instancetype)init
{
    if (self = [super init])
    {
        self.title = @"ENTRADES";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [@[self.seasonContainer, self.dayTicketContainer, self.hotelContainer, self.tresCContainer] enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [tapGesture.rac_gestureSignal subscribeNext:^(id x) {
            [self linkPressed:subview];
        }];
        
        [subview addGestureRecognizer:tapGesture];
    }];
    
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont em_boldFontOfSize:16.0];
    }];
    [self.bodyLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.font = [UIFont em_romanFontOfSize:16.0];
    }];
}

#pragma mark - Actions

- (IBAction)linkPressed:(UIView *)sender
{
    [self openTicketLink:[NSURL URLWithString:sender.tag == 3 ? @"http://www.tresc.cat/fitxa/concerts/43054/Embassat-2014" : @"https://www.ticketea.com/embassat-2014-festival-independent-del-valles/"]];
}

- (void)openTicketLink:(NSURL *)link
{
    [[UIApplication sharedApplication] openURL:link];
}

@end
