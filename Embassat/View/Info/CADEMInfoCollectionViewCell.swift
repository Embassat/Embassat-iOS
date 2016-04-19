//
//  CADEMInfoCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit
import TTTAttributedLabel

public class CADEMInfoCollectionViewCell: CADRootCollectionViewCell, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var bodyLabel: TTTAttributedLabel?
    public var body: String = "" {
        didSet {
            bodyLabel?.text = body
        }
    }
    public var links: ([NSURL], [NSRange]) = ([], []) {
        didSet {
            for (index, link) in links.0.enumerate() {
                bodyLabel?.addLinkToURL(link, withRange: links.1[index])
            }
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        bodyLabel?.font = UIFont.detailFont(ofSize: 15.0)
        bodyLabel?.linkAttributes = [kCTForegroundColorAttributeName: UIColor.whiteColor(),
            kCTUnderlineStyleAttributeName: 1];
        bodyLabel?.activeLinkAttributes = [kCTForegroundColorAttributeName: UIColor.emBarTintColor()];
        bodyLabel?.delegate = self
    }

    public func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
}
