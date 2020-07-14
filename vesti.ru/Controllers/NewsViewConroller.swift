//
//  NewsViewConroller.swift
//  vesti.ru
//
//  Created by Arden  on 10.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

class NewsViewConroller: UIViewController {

    @IBOutlet weak var pubDate: UILabel!
    @IBOutlet weak var pubTitle: UILabel!
    @IBOutlet weak var fullText: UILabel!
    @IBOutlet weak var pubImage: UIImageView!
    
    var tmpTitle = ""
    var tmpDate = ""
    var tmpFullText = ""
    var tmpImage: UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pubTitle.text = tmpTitle
        pubDate.text = tmpDate
        fullText.text = tmpFullText
        pubImage.image = tmpImage
        
        pubTitle.numberOfLines = 0
        fullText.numberOfLines = 0
        fullText.sizeToFit()
        
    }

}
