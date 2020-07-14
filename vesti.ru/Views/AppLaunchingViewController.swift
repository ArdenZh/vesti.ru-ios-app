//
//  AppLaunchingViewController.swift
//  vesti.ru
//
//  Created by Arden  on 12.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

class AppLaunchingViewController: UIViewController {

    var news: [News]?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barStyle = .black
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        spinner.stopAnimating()
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func fetchData()
    {
        let feedParser = Parser()
        feedParser.parseFeed(url: "https://www.vesti.ru/vesti.rss") { (rssItems) in
            self.news = rssItems
            
            DispatchQueue.main.async{
                self.performSegue(withIdentifier: "didFinishLoading", sender: self)
            }
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "didFinishLoading"{
            let destinationVC = segue.destination as! NewsFeedViewController
            
            destinationVC.news = news
        }
    }

}
