//
//  CategoriesViewController.swift
//  vesti.ru
//
//  Created by Arden  on 12.07.2020.
//  Copyright © 2020 Arden Zhakhin. All rights reserved.
//

import UIKit

protocol ChangeCategoryDelegate {
    func userPickedCategory(category: String)
}

class CategoriesViewController: UITableViewController {

    
    var categoriesInSet: Set<String> = []
    var categoriesInArray: [String] = []
    
    var delegate : ChangeCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesInArray = categoriesInSet.sorted()
        
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        header.backgroundColor = UIColor(named: "appColor")
        
        let headerTitle = UILabel(frame: header.bounds)
        headerTitle.text = "Категории"
        headerTitle.font = .boldSystemFont(ofSize: 22)
        headerTitle.textColor = .white
        headerTitle.textAlignment = .center
        header.addSubview(headerTitle)
        
        tableView.tableHeaderView = header
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesInArray.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        if indexPath.row == 0{
            cell.textLabel?.text = "Показать все"
        }else{
            cell.textLabel?.text = categoriesInArray[indexPath.row-1]
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let categoryName = tableView.cellForRow(at: indexPath)?.textLabel?.text{
            delegate?.userPickedCategory(category: categoryName)
        }

        self.dismiss(animated: true, completion: nil)
    }
    
}

