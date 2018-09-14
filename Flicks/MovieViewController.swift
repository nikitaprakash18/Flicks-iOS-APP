//
//  MovieViewController.swift
//  Flicks
//
//  Created by NikitaPrakash Patil on 6/6/18.
//  Copyright © 2018 NikitaPrakash Patil. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{

    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    var filter_Movies:[NSDictionary]?
    var searchResultsShown = false
    var movieEndPoint: String!
    @IBOutlet weak var MovietableView: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       MovietableView.delegate = self
       MovietableView.dataSource = self
       self.MovietableView.reloadData()
        
       searchbar.showsCancelButton = true
        searchbar.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationItem.titleView = searchbar
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 255.0,
                                                                        green: 194.0,
                                                                        blue: 14.0,
                                                                        alpha: 1)
        networkConnection()
        
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func networkConnection(){
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(movieEndPoint!)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print("responseDictionary: \(responseDictionary)")
                        
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.MovietableView.reloadData()
                        self.refreshControl.endRefreshing()
                        
                    }
                }
                else {
                    print("Network Error")
                   // self.toggleNetWorkError(hideErrorValue: false)
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchResultsShown) {
            return filter_Movies?.count ?? 0
        }
        return movies?.count ?? 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = MovietableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieTableCell
        let movie: NSDictionary?
        
        if(searchResultsShown) {
            movie = filter_Movies?[indexPath.row]
        } else {
            movie = movies?[indexPath.row]
        }
       
        let title = movie?["title"] as! String
        let Overview = movie?["overview"] as! String
        cell.movieTitle.text = title
        cell.movieOverview.text = Overview
        if let posterPath = movie?["poster_path"] as? String{
            
            let baseurl = "https://image.tmdb.org/t/p/original"
            let imageurl = NSURL(string: baseurl+posterPath)
            cell.movieImage.setImageWith(imageurl! as URL)
        }
        cell.selectionStyle = .none
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.backgroundColor = UIColor(red: 255.0,
                                           green: 194.0,
                                           blue: 14.0,
                                           alpha: 1)
        let Text = searchBar.text?.lowercased()
        if(Text == "") {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        
        filter_Movies = movies?.filter({ (movie: NSDictionary) -> Bool in
            let title = movie["title"] as! String
            return (title.lowercased().contains(Text!))
        })
        searchResultsShown = true
        self.MovietableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchResultsShown = true
        searchBar.endEditing(true)
       self.MovietableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchResultsShown = false
        self.MovietableView.reloadData()
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = MovietableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! MovieDetailViewController
        detailViewController.movie = movie
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
