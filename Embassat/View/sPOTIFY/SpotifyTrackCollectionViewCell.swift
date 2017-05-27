//
//  SpotifyTrackCollectionViewCell.swift
//  Embassat
//
//  Created by Joan Romano on 28/5/17.
//  Copyright © 2017 Crows And Dogs. All rights reserved.
//

import UIKit

final class SpotifyTrackCollectionViewCell: RootCollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.detailFont(ofSize: 15.0)
        label.textColor = .primary
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectElements()
            } else {
                deselectElements()
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                selectElements()
            } else {
                deselectElements()
            }
        }
    }
    
    override func setupView() {
        super.setupView()
        
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.useAndActivate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        )
    }
    
    fileprivate func selectElements() {
        contentView.backgroundColor = UIColor.primary.withAlphaComponent(0.5)
    }
    
    fileprivate func deselectElements() {
        contentView.backgroundColor = .secondary
    }
}
