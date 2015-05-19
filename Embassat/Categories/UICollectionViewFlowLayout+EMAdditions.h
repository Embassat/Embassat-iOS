//
//  UICollectionViewFlowLayout+EMAdditions.h
//  Embassa't
//
//  Created by Joan Romano on 19/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewFlowLayout (EMAdditions)

- (UIEdgeInsets)insetsForVerticallyCenteredSectionInScreenWithRows:(NSInteger)numberOfRows andColumns:(NSInteger)numberOfColumns;

@end
