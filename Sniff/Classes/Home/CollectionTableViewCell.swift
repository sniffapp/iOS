//
//  HomeCollectionTableViewCell.swift
//  Sniff
//
//  Created by Andrea Ferrando on 31/10/2016.
//  Copyright © 2016 Matchbyte. All rights reserved.
//

import Foundation

class HomeCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(title: String, collectionViewTag: Int) {
        lbTitle.text = title
        collectionView.tag = collectionViewTag
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        lbTitle.text = nil
    }
}
