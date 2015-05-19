//
//  UICollectionViewFlowLayout+EMAdditions.m
//  Embassa't
//
//  Created by Joan Romano on 19/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

#import "UICollectionViewFlowLayout+EMAdditions.h"

@implementation UICollectionViewFlowLayout (EMAdditions)

- (UIEdgeInsets)insetsForVerticallyCenteredSectionInScreenWithRows:(NSInteger)numberOfRows andColumns:(NSInteger)numberOfColumns
{
    CGFloat totalHeight = CGRectGetHeight(self.collectionView.bounds) + self.collectionView.contentOffset.y,
            totalWidth = CGRectGetWidth(self.collectionView.bounds),
            verticalInset = (totalHeight - (self.itemSize.height * numberOfRows + self.minimumLineSpacing)) / 2.0,
            horizontalInset = (totalWidth - (self.itemSize.width * numberOfColumns + self.minimumInteritemSpacing)) / 2.0;
    
    return UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
}

@end
