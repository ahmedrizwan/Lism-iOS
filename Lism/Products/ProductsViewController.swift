//
//  ProductViewController.swift
//  Lism
//
//  Created by Nofel Mahmood on 09/02/2017.
//  Copyright © 2017 TwinBinary. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController {

    let productCollectionViewCellReuseIdentifier = "productCollectionViewCellReuseIdentifier"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.tintColor = UIColor.blue
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: self)
        controller.searchBar.searchBarStyle = .minimal
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.searchBar.delegate = self
        
        return controller
    }()
    
    let products: [String] = ["One", "Two", "Three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: productCollectionViewCellReuseIdentifier)
        view.backgroundColor = UIColor.white
        
       // let barButtonItem = UIBarButtonItem(customView: searchController.searchBar)
        searchController.definesPresentationContext = true
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
        navigationController?.navigationItem.leftBarButtonItem = barButtonItem
        navigationController?.navigationItem.titleView = searchController.searchBar
        
        view.addSubview(collectionView)
        let cvWidthConstraint = NSLayoutConstraint(item: collectionView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0.0)
        let cvHeightConstraint = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0.0)
        view.addConstraints([cvWidthConstraint, cvHeightConstraint])
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

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCollectionViewCellReuseIdentifier, for: indexPath)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate 

extension ProductsViewController: UICollectionViewDelegate {
    
}

// MARK: - UISearchControllerDelegate 

extension ProductsViewController: UISearchControllerDelegate {
    
}

// MARK: - UISearchResultsUpdating

extension ProductsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - UISearchBarDelegate

extension ProductsViewController: UISearchBarDelegate {
    
}
