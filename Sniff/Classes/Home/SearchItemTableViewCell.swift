//
//  SearchItemTableViewCell.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class SearchItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(title: String, subTitle: String) {
        lbTitle.text = title
        lbSubtitle.text = title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbTitle.text = nil
        lbSubtitle.text = nil
    }
    
}
