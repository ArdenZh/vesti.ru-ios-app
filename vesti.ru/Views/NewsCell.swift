//
//  NewsCell.swift
//  vesti.ru
//
//  Created by Arden  on 07.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var pubDate: UILabel!
    @IBOutlet weak var pubTitle: UILabel!
    @IBOutlet weak var pubImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pubTitle.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
