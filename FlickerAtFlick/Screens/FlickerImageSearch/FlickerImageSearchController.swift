//
//  FlickerImageSearchController.swift
//  FlickerAtFlick
//
//  Created by sriharshay on 28/09/19.
//  Copyright © 2019 harsha. All rights reserved.
//

import UIKit

private let headerCellId = "headerCellId"

class FlickerImageSearchController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = FlickerImageSearchViewModel(router: Router())
    
    lazy var searchBar: UISearchBar = {
        let s = UISearchBar()
        s.placeholder = "Search Flicker Images"
        s.delegate = self
        s.tintColor = .white
        s.barStyle = .default
        s.backgroundImage = UIImage()
        s.barTintColor = UIColor(red: 235/255, green: 235/255, blue: 242/255, alpha: 1)
        s.sizeToFit()
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialUISetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func initialUISetup() {
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionHeadersPinToVisibleBounds = true
        self.registerCollectionReusableViews()
        self.bindListeners()
    }
    
    fileprivate func registerCollectionReusableViews() {
        self.collectionView.register(FlickerImageCell.self)
        self.collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
    }
    
    fileprivate func bindListeners() {
        self.viewModel.notifyCollectionReload = {[unowned self] in
            self.collectionView.reloadData()
        }
        self.viewModel.notifyErrors = {[unowned self] message in
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:{ _ in
                self.searchBar.text = ""
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension  FlickerImageSearchController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.flickerImageSearchModel.photos.photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FlickerImageCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.imageUrlString = Utils.createFlickerImageUrlStringFrom(self.viewModel.flickerImageSearchModel.photos.photo[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath)
        header.addSubview(self.searchBar)
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.leftAnchor.constraint(equalTo: header.leftAnchor).isActive = true
        self.searchBar.rightAnchor.constraint(equalTo: header.rightAnchor).isActive = true
        self.searchBar.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        self.searchBar.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        return header
    }
}

extension FlickerImageSearchController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.flickerImageSearchModel.photos.photo.count - 15 {
            self.viewModel.requestNextPage()
        }
    }
}

extension FlickerImageSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.width / 3 - 2
        return CGSize(width: width, height: width)
    }
}

extension FlickerImageSearchController: UISearchBarDelegate {
    
    // TODO: Get search results based on each charcter entered by user (with certain threshold set likely 3 characters)
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.viewModel.searchFor(image: self.searchBar.text)
    }
}
