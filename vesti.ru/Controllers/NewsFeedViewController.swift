//
//  ViewController.swift
//  vesti.ru
//
//  Created by Arden  on 07.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

class NewsFeedViewController: UITableViewController, ChangeCategoryDelegate {
    
    var news: [News]?
    var sortedNews: [News]?
    var selectedCategory: String = "Показать все"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(named: "appColor")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 22)]
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)

        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

        tableView.tableFooterView = UIView()
        
        sortedNews = news
        
    }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedNews?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! NewsCell
    
        cell.pubImage.image = sortedNews?[indexPath.row].UIimage
        
        cell.pubDate.text = sortedNews?[indexPath.row].date
        cell.pubTitle.text = sortedNews?[indexPath.row].title
    
        return cell
    }
      
    
    //MARK: - segues
    
    
    @IBAction func DidFilterButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "showCategories", sender: self)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let destinationVC = segue.destination as! NewsViewConroller

            if let indexPath = tableView.indexPathForSelectedRow{
                
                if let title = sortedNews?[indexPath.row].title,
                    let date = sortedNews?[indexPath.row].date,
                    let fullText = sortedNews?[indexPath.row].fullText,
                    let image = sortedNews?[indexPath.row].UIimage{
                    
                    destinationVC.tmpTitle = title
                    destinationVC.tmpDate = date
                    destinationVC.tmpFullText = fullText
                    destinationVC.tmpImage = image
                    
                }
            }

        }else{
            let destinationVC = segue.destination as! CategoriesViewController
            
            if let tmpNews = news{
                for news in tmpNews{
                    if let newsCategory = news.category{
                        destinationVC.categoriesInSet.insert(newsCategory)
                    }
                }
            }
            destinationVC.delegate = self
        }
    }
    

    //MARK: - pull to refresh
    
    @objc func refresh(sender:AnyObject)
    {
        fetchData()

        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func fetchData()
    {
        let feedParser = Parser()
        feedParser.parseFeed(url: "https://www.vesti.ru/vesti.rss") { (rssItems) in
            self.news = rssItems

            DispatchQueue.main.async {
                self.userPickedCategory(category: self.selectedCategory)
            }
        }
    }
    
    func userPickedCategory(category: String){
        sortedNews = []
        selectedCategory = category
        if selectedCategory == "Показать все"{
            sortedNews = news
        }else{
            if let tmpNews = news{
                for news in tmpNews{
                    if news.category == selectedCategory{
                        sortedNews?.append(news)
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
}
