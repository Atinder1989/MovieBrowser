//
//  HomeView.swift
//  Movie Browser
//
//  Created by Atinderpal Singh on 01/12/17.
//  Copyright © 2017 XYZ. All rights reserved.
//

import UIKit
import SDWebImage

class HomeView: UIViewController {

    @IBOutlet weak var moviesCollectionView : UICollectionView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var homeViewModel = HomeViewModel.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "Most Popular Movies"

        searchBar.delegate = self
        
        homeViewModel.fetchMostPopularMovies()
        
        homeViewModel.reloadCollectionData = {
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
        
    }

    @IBAction func sortMovie(_ sender: Any) {
        
        let alertview = UIAlertController.init(title: "Sort Movie", message: "", preferredStyle: .actionSheet)
        alertview.addAction(UIAlertAction.init(title: "Most Popular", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.moviesCollectionView.contentOffset = CGPoint.zero
                self.homeViewModel.sortByMostPopular()
            }
        }))
        
        alertview.addAction(UIAlertAction.init(title: "Top Rated", style: .default, handler: { (action) in
            DispatchQueue.main.async {
                self.moviesCollectionView.contentOffset = CGPoint.zero
                self.homeViewModel.sortByMostRated()
            }
        }))
        
        alertview.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) in

        }))
        
        self.present(alertview, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK:- CollectionView DataSource
extension HomeView : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return homeViewModel.movieCollection.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == homeViewModel.movieCollection.count
        {
            let footerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath)
            let activity = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
            activity.center = footerCell.contentView.center
            footerCell.addSubview(activity)
            activity.startAnimating()
            return footerCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCell
        cell.movieTitle.text = homeViewModel.movieCollection[indexPath.row].title
        
        let url = WebserviceManager.sharedInstance.getPosterUrl(path: homeViewModel.movieCollection[indexPath.row].poster_path ?? "")
        cell.posterImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "MoviePlaceholder")) { (image, error, type, url) in
            
        }
        return cell
    }
}

//MARK:- CollectionView Delegates
extension HomeView : UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie : Movie = homeViewModel.movieCollection[indexPath.row]
        let detailView = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailView") as! MovieDetailView
        detailView.movie = selectedMovie
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == homeViewModel.movieCollection.count
        {
            if let searchText = searchBar.text , searchText != "" {
                self.homeViewModel.callServiceForKeyword(keyword: searchText)
            }
            else
            {
                self.homeViewModel.fetchMostPopularMovies()
            }
        }
    }
}

//MARK:- CollectionView FlowLayout Delegate
extension HomeView : UICollectionViewDelegateFlowLayout
{
 func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
        return CGSize.init(width: (UIScreen.main.bounds.width - 20 - 16) / 2, height: 200)
    }
}

//MARK:- Searchbar Delegate
extension HomeView : UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if let searchText = searchBar.text , searchText != ""
        {
            self.homeViewModel.resetCounters()
            self.homeViewModel.callServiceForKeyword(keyword: searchText)
            self.moviesCollectionView.contentOffset = CGPoint.zero
        }
        self.view.endEditing(true)

    }
}

