//
//  SearchUserController.swift
//
//  Created by Gints Murans on 18.02.16.
//  Copyright © 2016 Gints Murans. All rights reserved.
//

import UIKit


enum BasicSearchControllerError : ErrorType {
    case LoadDataNotImplemented
    case AdditionalUserInfoDataRequired
    case GeneralError(message: String)

    var description: String {
        get {
            switch self {
            case .LoadDataNotImplemented:
                return "Method loadData is not yet overridden"

            case .AdditionalUserInfoDataRequired:
                return "Some additional data set in userInfo is required"

            case .GeneralError(let message):
                return "Error: \(message)"
            }
        }
    }
}

typealias BasicSearchControllerCallback = (selectedItem: Dictionary<String, AnyObject!>?)->()


/**
 BasicSearchController - Interface for basic search UITableView, can be customized when extended.

 FilterData example for scope:
     let categoryMatch = (scope.lowercaseString == "all" || (item["group_name"] as! String).lowercaseString == scope.lowercaseString)
     if (searchText == "") {
         return categoryMatch
     } else {
         return categoryMatch && (
             (item["ean_code"] as! String).lowercaseString.containsString(searchText.lowercaseString) ||
                 (item["title"] as! String).lowercaseString.containsString(searchText.lowercaseString)
         )
     }
 */
class BasicSearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)

    var userInfo: NSMutableDictionary! = NSMutableDictionary()
    var tableReuseIdentificator = "BasicSearchControllerCell"

    var data: [Dictionary<String, AnyObject!>]?
    var filteredData: [Dictionary<String, AnyObject!>]?
    var groups: [String]? = nil {
        didSet {
            if (groups != nil) {
                groups!.insert("ALL", atIndex: 0)
                searchController.searchBar.scopeButtonTitles = groups
                searchController.searchBar.sizeToFit()
            }
        }
    }
    var selectedItem: Dictionary<String, AnyObject>?
    var selectItemCallback: BasicSearchControllerCallback?


    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBarHidden = false
        self.definesPresentationContext = true

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.scopeButtonTitles = groups

        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.sizeToFit()

        // Refresh control
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)

        // Load data
        try! self.loadData()
    }

    deinit {
        // Fix UISearchController issues
        if searchController.view.superview != nil {
            searchController.view.removeFromSuperview()
        }
    }


    // MARK: - Helpers
    func loadData(ignoreCache: Bool = false) throws {
        throw BasicSearchControllerError.LoadDataNotImplemented
    }

    @IBAction func refreshData(sender: AnyObject?) {
        try! self.loadData(true)
    }

    func displayText(item: Dictionary<String, AnyObject!>) -> String? {
        return item["name"] as? String
    }

    func displayDetailsText(item: Dictionary<String, AnyObject!>) -> String? {
        return item["name"] as? String
    }

    func filterData(searchText: String, scope: String?) -> (Dictionary<String, AnyObject!>) -> (Bool) {
        return {(item : Dictionary<String, AnyObject!>) -> Bool in
            return (item["name"] as! String).lowercaseString.containsString(searchText.lowercaseString)
        }
    }


    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return filteredData!.count
        }
        return data == nil ? 0 : data!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(tableReuseIdentificator, forIndexPath: indexPath)

        let item: Dictionary<String, AnyObject!>
        if searchController.searchBar.text != "" {
            item = filteredData![indexPath.row]
        } else {
            item = data![indexPath.row]
        }

        cell.textLabel!.text = self.displayText(item)
        cell.detailTextLabel?.text = self.displayDetailsText(item)

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.searchBar.text != "" {
            selectedItem = filteredData![indexPath.row]
        } else {
            selectedItem = data![indexPath.row]
        }

        if let callback = self.selectItemCallback {
            callback(selectedItem: self.selectedItem)
        }
    }

    // MARK: - Filter
    func filterContentForSearchText(searchText: String, scope: String?) {
        filteredData = data!.filter(self.filterData(searchText, scope: scope))
        tableView.reloadData()
    }


    // MARK: - UISearchBar Delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
         filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }


    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        var scope: String?
        if let scopes = searchBar.scopeButtonTitles {
            scope = scopes[searchBar.selectedScopeButtonIndex]
        }

        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    
}
