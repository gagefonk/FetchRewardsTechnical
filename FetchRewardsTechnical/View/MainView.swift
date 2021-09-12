//
//  MainView.swift
//  FetchRewardsTechnical
//
//  Created by Gage Fonk on 9/10/21.
//

import UIKit

class MainView: UIViewController {
    
    //create VM
    let mainViewVM = MainViewVM()
    
    //indicator
    var indicator = UIActivityIndicatorView()
    
    //create tableView
    let tableView: UITableView = {
        let tableView = UITableView()
        //create cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        //add title
        title = "Recipes"
        //add tableview
        view.addSubview(tableView)
        //add datasource/delegates
        tableView.dataSource = self
        tableView.delegate = self
        //add indicator
        view.addSubview(indicator)
        indicator.center = view.center
        
        fetch()
    }
    
    override func viewDidLayoutSubviews() {
        //configure tableview
        tableView.frame = view.frame
        
    }
    
    //fetch data
    func fetch() {
        //start indicator animation
        activityIndicator()
        indicator.startAnimating()
        indicator.backgroundColor = .white
        
        //get data
        mainViewVM.fetchData {
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                self.tableView.reloadData()
            }
        }
    }
    
    //refresh control
    @objc private func refresh(_ sender: AnyObject) {
        fetch()
        sender.endRefreshing()
    }
    
    // indicator
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = .large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }


}

extension MainView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainViewVM.displayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mainViewVM.displayData[section].category
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !mainViewVM.displayData[section].meals.isEmpty {
            return mainViewVM.displayData[section].meals.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = mainViewVM.displayData[indexPath.section].meals[indexPath.row].strMeal
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        activityIndicator()
        indicator.startAnimating()
        let meal = mainViewVM.displayData[indexPath.section].meals[indexPath.row]
        mainViewVM.getMealDetails(mealID: meal.idMeal) { mealDetails in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                let detailView = DetailedView(meal: mealDetails)
                self.navigationController?.pushViewController(detailView, animated: true)
            }
            
        }
    }
    
}

