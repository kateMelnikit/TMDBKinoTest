//
//  PlotCell.swift
//  kino
//
//  Created by Kate on 30/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PlotCell: UITableViewCell {

    @IBOutlet weak var overviewLabel: UILabel!
    
    private let animationFadeInDuration: TimeInterval = 0.3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var item: MTMovieDetails! {
        didSet {
            self.setInfo()
        }
    }
    
    private func setInfo() {
        self.overviewLabel.text = self.item.overview
    }
    
    
}