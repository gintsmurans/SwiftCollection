//
//  SearchUserController.swift
//
//  Created by Gints Murans on 18.02.16.
//  Copyright © 2016 Gints Murans. All rights reserved.
//

import UIKit


public enum BasicSearchControllerError : Error {
    case loadDataNotImplemented
    case additionalUserInfoDataRequired
    case generalError(message: String)

    var description: String {
        get {
            switch self {
            case .loadDataNotImplemented:
                return "Method loadData is not yet overridden"

            case .additionalUserInfoDataRequired:
                return "Some additional data set in userInfo is required"

            case .generalError(let message):
                return "Error: \(message)"
            }
        }
    }
}

public typealias BasicSearchControllerCallback = (_ selectedItem: Dictionary<String, Any>?)->()


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
open class BasicSearchController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let searchController = UISearchController(searchResultsController: nil)

    open var userInfo: NSMutableDictionary! = NSMutableDictionary()
    open var tableReuseIdentificator = "BasicSearchControllerCell"

    open var data: [Dictionary<String, Any>]?
    open var filteredData: [Dictionary<String, Any>]?
    open var groups: [String]? = nil {
        didSet {
            if (groups != nil) {
                groups!.insert("ALL", at: 0)
                searchController.searchBar.scopeButtonTitles = groups
                searchController.searchBar.sizeToFit()
            }
        }
    }
    open var selectedItem: Dictionary<String, Any>?
    open var selectItemCallback: BasicSearchControllerCallback?


    // MARK: - View Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
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
        self.refreshControl?.addTarget(self, action: #selector(self.refreshData(_:)), for: UIControlEvents.valueChanged)

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
    open func loadData(_ ignoreCache: Bool = false) throws {
        throw BasicSearchControllerError.loadDataNotImplemented
    }

    @IBAction open func refreshData(_ sender: AnyObject?) {
        try! self.loadData(true)
    }

    open func displayText(_ item: Dictionary<String, Any>, cell: UITableViewCell? = nil) -> String? {
        return item["name"] as? String
    }

    open func displayDetailsText(_ item: Dictionary<String, Any>, cell: UITableViewCell? = nil) -> String? {
        return item["name"] as? String
    }

    open func filterData(_ searchText: String, scope: String?) -> (Dictionary<String, Any>) -> (Bool) {
        return {(item : Dictionary<String, Any>) -> Bool in
            return (item["name"] as! String).lowercased().contains(searchText.lowercased())
        }
    }


    // MARK: - Table View
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.text != "" {
            return filteredData!.count
        }
        return data == nil ? 0 : data!.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableReuseIdentificator, for: indexPath)

        let item: Dictionary<String, Any>
        if searchController.searchBar.text != "" {
            item = filteredData![(indexPath as NSIndexPath).row]
        } else {
            item = data![(indexPath as NSIndexPath).row]
        }

        cell.textLabel!.text = self.displayText(item, cell: cell)
        cell.detailTextLabel?.text = self.displayDetailsText(item, cell: cell)

        return cell
    }

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.searchBar.text != "" {
            selectedItem = filteredData![(indexPath as NSIndexPath).row]
        } else {
            selectedItem = data![(indexPath as NSIndexPath).row]
        }

        if let callback = self.selectItemCallback {
            callback(self.selectedItem)
        }
    }

    // MARK: - Filter
    open func filterContentForSearchText(_ searchText: String, scope: String?) {
        filteredData = data!.filter(self.filterData(searchText, scope: scope))
        tableView.reloadData()
    }


    // MARK: - UISearchBar Delegate
    open func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
         filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }


    // MARK: - UISearchResultsUpdating Delegate
    open func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        var scope: String?
        if let scopes = searchBar.scopeButtonTitles {
            scope = scopes[searchBar.selectedScopeButtonIndex]
        }

        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    
}
