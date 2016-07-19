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

class MovieFlicksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var moveFlicksTableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        moveFlicksTableView.dataSource = self
        moveFlicksTableView.delegate = self
        networkErrorView.hidden = true
        
        let api_key = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
                                                                      completionHandler: { (dataOrNil, response, error) in
                                                                        if let data = dataOrNil {
                                                                            if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                                                                                data, options:[]) as? NSDictionary {
                                                                                NSLog("response: \(responseDictionary)")
                                                                                MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                                self.movies = responseDictionary["results"] as? [NSDictionary]
                                                                                self.moveFlicksTableView.reloadData()
                                                                            }
                                                                        }else{
                                                                            self.networkErrorView.hidden = false
                                                                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                                                                        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = moveFlicksTableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as!DetailViewController
        detailViewController.movie = movie
    }


}

