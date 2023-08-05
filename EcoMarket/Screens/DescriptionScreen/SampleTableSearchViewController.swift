import UIKit

//MARK: a separate view controller for showing the search results works better with a storyboard or xib.
class ResultsTableViewController: UITableViewController {
    var items = [String] ()
    let CELLID = "CELLID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.CELLID)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELLID, for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
}

//MARK: sample tableview controller with search controller
class SampleTableSearchViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    var items = [String]()
    var _resultsTableController: ResultsTableViewController? = nil
    var progressView: UIProgressView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELLID")
        
        self._resultsTableController = ResultsTableViewController(style: .plain)
        //programmatically configure a search controller (and result view controller) in iOS 11
        self.navigationItem.searchController = UISearchController(searchResultsController: self._resultsTableController)
        self.navigationItem.searchController?.searchResultsUpdater = self
        self.navigationItem.searchController?.delegate = self
        definesPresentationContext = true
        self.navigationItem.searchController?.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController?.searchBar.delegate = self
        
        //a progress view is handy when running an expensive search loop
        self.progressView = UIProgressView(progressViewStyle: .bar)
        self.progressView?.frame = CGRect(x: 0, y: self.navigationItem.searchController!.searchBar.frame.height, width: self.navigationItem.searchController!.searchBar.frame.width, height: 2)
        self.navigationItem.searchController?.searchBar.addSubview(self.progressView!)
        
        for _ in 0 ..< 100 {
            items.append("\(arc4random_uniform(10000))")
        }
        self.tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELLID", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    //this serial queue makes sure there's only one search loop going on at one time
    var serial_search = DispatchQueue(label: "ser_search")
    
    var cancel = false
    var inProgress = false
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //when search text is changed, we cancel an ongoing search loop
        if inProgress {
            self.cancel = true
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let t = self.navigationItem.searchController?.searchBar.text else {
            return
        }
        
        self._resultsTableController?.items  = [String]()
        //the real search here. not that expensive in this demo.
        self.items.forEach { (item) in
            if item.contains(t) {
                self._resultsTableController?.items.append(item)
            }
        }
        
        //simulation of expensive loop
        self.serial_search.async {
            var str = " dummy"
            let max:Float = 1000000.0 //expensive!
            self.inProgress = true
            
            //an expensive search loop
            for t in 0..<Int(max){
                str.append(" dummy\(t)")
                
                //when text is changed, we cancel the ongoing search loop
                if self.cancel {
                    self.cancel = false
                    return
                }
                
                //update the progress bar in the main thread.
                DispatchQueue.main.async {
                    self.progressView?.progress = Float(t) / max
                }
            }
            
            //end the search loop by updating the table view.
            DispatchQueue.main.async {
                self._resultsTableController?.tableView.reloadData()
                print("done \(t)")
            }
            self.inProgress = false
        }
    }
}
