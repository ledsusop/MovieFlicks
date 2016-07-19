//
//  DetailViewController.swift
//  MovieFlicks
//
//  Created by Ledesma Usop Jr. on 7/18/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["title"]
        let overview = movie["overview"]
        
        titleLabel.text = title as? String
        overviewLabel.text = overview as? String
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: baseUrl + posterPath)
            let imageRequest = NSURLRequest(URL: posterURL!)
            
            self.posterImageView.setImageWithURLRequest(
                imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    
                    // imageResponse will be nil if the image is cached
                    if imageResponse != nil {
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = image
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                        })
                    } else {
                        self.posterImageView.image = image
                    }
                },
                failure: { (imageRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
