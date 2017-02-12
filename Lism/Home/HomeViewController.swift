//
//  HomeViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 10/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       /* let barButtonItem = UIBarButtonItem(customView: searchController.searchBar)
        print("NV NAVIGATION CONTROLLER \(parent?.navigationController)")
        navigationController?.navigationItem.rightBarButtonItem = barButtonItem
        
        let item1 = ProductsViewController()
        let icon1 = UITabBarItem(title: "Title", image: UIImage(named: "Digits.png"), selectedImage: UIImage(named: "Digits.png"))
        item1.tabBarItem = icon1
        
        let controllers = [item1]
        viewControllers = controllers */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UISearchControllerDelegate 

extension HomeViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchBarDelegate 

extension HomeViewController: UISearchBarDelegate {
    
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
