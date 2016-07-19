//
//  MovieNavViewController.swift
//  MovieFlicks
//
//  Created by Ledesma Usop Jr. on 7/19/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class MovieNavViewController: UINavigationController {
    
    var endpoint:String = "now_playing"
    var listModeTitle = "Now Playing"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setMovieEndpoint(movieEndPoint:String?) {
        if let movieEndpt = movieEndPoint{
            self.endpoint = movieEndpt
        }else {
            self.endpoint = "now_playing"
        }
    }
    
    func setMovieListModeTitle(title:String?) {
        if let lbel = title {
            self.listModeTitle = lbel
        }else{
            self.listModeTitle = "Now Playing"
        }
    }
    

}
