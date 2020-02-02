//
//  RoutesListViewController.swift
//  RouteTracer
//
//  Created by Abraham Escamilla Pinelo on 30/01/20.
//  Copyright © 2020 Abraham Escamilla Pinelo. All rights reserved.
//

import UIKit
import RealmSwift

class RoutesListViewController: UIViewController {
    
    //MARK: - UI
    @IBOutlet weak var routesTableView: UITableView!
    
    //MARK: - Properties
    let routes = TracerRealmManager.getRoutes()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.routesTableView.reloadData()
    }
    
    //MARK: - Setup
    private func setup() {
        self.title = "My routes"
        self.setupTableView()
    }
    
    private func setupTableView() {
        self.routesTableView.delegate = self
        self.routesTableView.dataSource = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RoutesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let route = self.routes[indexPath.row]
        cell.textLabel?.text = route.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.routes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
