//
//  CADEMInfoCollectionViewCell.swift
//  Embassa't
//
//  Created by Joan Romano on 24/05/15.
//  Copyright (c) 2015 Crows And Dogs. All rights reserved.
//

import UIKit

public class CADEMInfoCollectionViewCell: CADRootCollectionViewCell, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var bodyLabel: TTTAttributedLabel?
    public var body: String = "" {
        didSet {
            bodyLabel?.text = body
        }
    }
    public var links: (Array<NSURL>, Array<NSRange>) = ([], []) {
        didSet {
            for var i = 0; i < links.0.count; i++
            {
                bodyLabel?.addLinkToURL(links.0[i], withRange: links.1[i])
            }
        }
    }
    
    public override func setupView() {
        super.setupView()
        
        bodyLabel?.font = UIFont.detailFont(ofSize: 15.0)
        bodyLabel?.linkAttributes = [kCTForegroundColorAttributeName: UIColor.whiteColor(),
            kCTUnderlineStyleAttributeName: 1];
        bodyLabel?.activeLinkAttributes = [kCTForegroundColorAttributeName: UIColor.em_barTintColor()];
        bodyLabel?.delegate = self
    }

    public func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
}
