//
//  MoviesCollectionViewController.swift
//  kino
//
//  Created by Kate on 29/03/2017.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MoviesCollectionViewCell"

class MoviesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var movies = [MTMovie]()
    var refreshControl: UIRefreshControl!
    weak var moviesViewController: MoviesViewController!
    var mode: Mode!
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(self.loadMovies), for: .valueChanged)
        self.collectionView!.addSubview(self.refreshControl)
    }

    func loadMovies() {
        self.page = 1
        let request = self.request(for: self.mode, page: self.page)
        MTNetwork.makeRequest(request: request) { (response: MTMoviesResponse?, error: Error?) in
            if let response = response {
                self.movies.removeAll()
                if self.mode == .Top {
                    let topMovies = response.results.prefix(10)
                    self.movies.append(contentsOf: topMovies)
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                self.collectionView!.reloadData()
                self.refreshControl.endRefreshing()
                
            }
        }
    }
    
    func request(for mode: Mode, page: Int) -> MTBaseRequest {
        switch mode {
        case .Popular:
            return MTPopularRequest(page: page)
        case .Upcoming:
            return MTUpcomingRequest(page: page)
        default:
            return MTTopRequest()
        }
    }
    
    func item(at indexPath: IndexPath) -> MTMovie {
        return self.movies[indexPath.row]
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: MovieDetailsTableViewController.self) {
            let destController = segue.destination as! MovieDetailsTableViewController
            let ip = self.collectionView!.indexPathsForSelectedItems!.first!
            destController.movie = self.item(at: ip)
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.movies.count <= indexPath.row {
        
            let request = self.request(for: self.mode, page: self.page + 1)
            
            MTNetwork.makeRequest(request: request) { (response: MTMoviesResponse?, error: Error?) in
                if let response = response {
                    self.movies.append(contentsOf: response.results)
                    self.collectionView!.reloadData()
                    self.page += 1
                }
            }

        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.mode! == .Top {
            return self.movies.count
        } else {
            return self.movies.count + 1
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.movies.count > indexPath.row {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
            cell.item = self.item(at: indexPath)
            return cell
        } else {
            let loadCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Load", for: indexPath)
            return loadCell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.bounds.size.width / 2)
        let height = CGFloat(3 * width / 2)
        return CGSize(width: width, height: height)
    }
}
