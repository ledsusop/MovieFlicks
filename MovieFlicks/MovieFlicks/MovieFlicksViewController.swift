//
//  ViewController.swift
//  MovieFlicks
//
//  Created by Ledesma Usop Jr. on 7/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieFlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var moveFlicksTableView: UITableView!
    @IBOutlet weak var movieFlicksGridView: UICollectionView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var layoutControl: UISegmentedControl!
    
    var movies: [NSDictionary]?
    var endpoint:String = "now_playing"
    
    let layoutTypes = ["list","grid"]
    let refreshControl = UIRefreshControl()
    let refreshGridControl = UIRefreshControl()
    var currentLayoutType = "list"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moveFlicksTableView.dataSource = self
        moveFlicksTableView.delegate = self
        
        movieFlicksGridView.dataSource = self
        movieFlicksGridView.delegate = self
        
        networkErrorView.hidden = true
        
        self.endpoint = (self.parentViewController as! MovieNavViewController).endpoint
        self.navigationItem.title = (self.parentViewController as! MovieNavViewController).listModeTitle
        
        self.refreshControl.addTarget(self, action: #selector(refreshMovieData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        moveFlicksTableView.addSubview(self.refreshControl)
        
        self.refreshGridControl.addTarget(self, action: #selector(refreshMovieData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        movieFlicksGridView.addSubview(self.refreshGridControl)
        
        if self.currentLayoutType == "grid"{
            refreshMovieData(self.refreshGridControl)
        }else{
           refreshMovieData(self.refreshControl)
        }

        
        
    }
    
    func refreshMovieData(refreshControl: UIRefreshControl) {
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let urlString = "https://api.themoviedb.org/3/movie/\(self.endpoint)?api_key=\(api_key)"
        let url = NSURL(string: urlString)
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        self.currentLayoutType = self.layoutTypes[layoutControl.selectedSegmentIndex]
        
        if self.currentLayoutType == "grid"{
            movieFlicksGridView.hidden = false
            moveFlicksTableView.hidden = true
        }else{
            movieFlicksGridView.hidden = true
            moveFlicksTableView.hidden = false
        }

        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                NSLog("response: \(responseDictionary)")
                                                                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                                if self.currentLayoutType == "list"{
                                                                                    self.moveFlicksTableView.reloadData()
                                                                                }else{
                                                                                    self.movieFlicksGridView.reloadData()
                                                                                }
                                                                            }
                                                                        }else{
                                                                            self.networkErrorView.hidden = false
                                                                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                        }
                                                                        
                                                                        refreshControl.endRefreshing()
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        }else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = moveFlicksTableView.dequeueReusableCellWithIdentifier("MovieFlicksCell",forIndexPath: indexPath) as! MovieFlicksCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.movieFlicksImageView.setImageWithURL(imageUrl!)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if let movies = movies {
            return movies.count
        }else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = movieFlicksGridView.dequeueReusableCellWithReuseIdentifier("MovieFlicksCollectionCell",forIndexPath: indexPath) as! MovieFlicksCollectionViewCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        
        cell.titleLabel.text = title
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterView.setImageWithURL(imageUrl!)
        }
        
        return cell
    }
    
    @IBAction func onLayoutChanged(sender: UISegmentedControl) {
        if self.currentLayoutType == "grid"{
            refreshMovieData(self.refreshGridControl)
        }else{
            refreshMovieData(self.refreshControl)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath:  NSIndexPath?
        if let cell = sender as? UITableViewCell {
            indexPath = moveFlicksTableView.indexPathForCell(cell)
        }else{
            indexPath = movieFlicksGridView.indexPathForCell(sender as! UICollectionViewCell)
        }
        
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as!DetailViewController
        detailViewController.movie = movie
    }


}

