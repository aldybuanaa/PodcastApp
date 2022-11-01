//
//  FavoritesViewController.swift
//  PodcastsApp
//
//  Created by Bayu Yasaputro on 26/10/22.
//

import UIKit
import CoreData

class FavoritesViewController: BaseViewController {
    let viewModel = PodcastsViewModel()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let inset: CGFloat = 20
    private let spacing: CGFloat = 12
    var favoriteCount = 0;
    private var favorited: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        let fetch = viewModel.getFavoritedData()
        favorited = fetch
        favoriteCount = (fetch as AnyObject).count
        
        collectionView?.reloadData()
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.reloadData()
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        collectionViewLayout.minimumLineSpacing = 30.0
        collectionViewLayout.minimumInteritemSpacing = spacing
        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.collectionViewLayout = collectionViewLayout
    }
}

// MARK: - UICollectionViewDataSource
extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return favoriteCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCellId", for: indexPath) as! FavoriteViewCell
        
        let width = floor((UIScreen.main.bounds.width - (inset * 2) - spacing) / 2)
        cell.widthConstraint.constant = width
        cell.setNeedsLayout()
        
//        let fetchData = self.viewModel.getAllDataFromCoreData()
        
        let index = indexPath.row
        cell.nameLabel.text = (favorited[index].self as AnyObject).trackName
        cell.artistLabel.text = (favorited[index].self as AnyObject).artistName

        
        cell.thubImageView.kf.setImage(with: URL(string: (favorited[index].self as AnyObject).artwork)) { (result) in
            switch result {
            case.success:
                cell.thubImageView.contentMode = .scaleAspectFill

            case.failure:
                cell.thubImageView.contentMode = .center
                cell.thubImageView.image = UIImage(systemName: "photo")

            }
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
