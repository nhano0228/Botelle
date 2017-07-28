//
//  AddGroceryController.swift
//  Botelle
//
//  Created by Akhil Sehgal on 7/25/17.
//  Copyright © 2017 Botelle. All rights reserved.
//

import UIKit
import Kanna


class addGroceryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var dataArray: [String]! = ["Search for an item"]
    
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.navigationItem.leftBarButtonItem?.title = "Cancel"
        self.title = "Add Grocery"
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        
        
        
        // Place the search bar view to the tableview headerview.
        tableView.tableHeaderView = searchController.searchBar

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        
        if shouldShowSearchResults {
            //cell.textLabel?.text = filteredArray[indexPath.row]
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        else {
            cell.textLabel?.text = dataArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        (self.navigationController?.viewControllers.first as! ViewController).myArray.append((tableView.cellForRow(at: indexPath)?.textLabel?.text)!)
        
        (self.navigationController?.viewControllers.first as! ViewController).tableView.reloadData()
        
        searchController.searchBar.resignFirstResponder()
        searchController.isActive = false
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if !shouldShowSearchResults {
            return
        }
        
        guard let searchString = searchController.searchBar.text else {
            return
        }
        
        let url = URL(string: "http://www.SupermarketAPI.com/api.asmx/COMMERCIAL_SearchByProductName?APIKEY=e459ef0739&ItemName="+searchString)
        if let doc = HTML(url: url!, encoding: .utf8) {
            let names = doc.xpath("//itemname")
            let pricing = doc.xpath("//pricing")
                for i in 0...names.count-1 {
                    dataArray.append(names[i].innerHTML!+": "+pricing[i].innerHTML!)
                }
        }
        
        /*// Filter the data array and get only those countries that match the search text.
        filteredArray = dataArray.filter({ (grocery) -> Bool in
            let countryText:NSString = grocery as NSString
            
            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })*/
        
        // Reload the tableview.
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        dataArray = []
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        dataArray = []
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        updateSearchResults(for: self.searchController)
        
        searchController.searchBar.resignFirstResponder()
    }
    
}
