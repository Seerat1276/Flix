//
//  MoviesViewController.swift
//  Flix
//
//  Created by Mac on 13/02/20.
//  Copyright © 2020 Seerat1276. All rights reserved.
//

import UIKit
import AlamofireImage


class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    // added the UITableViewDataSource,UITableViewDelegate
    
// Create the table view outlet
    @IBOutlet weak var tableView: UITableView!
    var movies = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Added these two lines
        tableView.dataSource = self
        tableView.delegate = self
        
       // Copied, API
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // load movies with the data
                self.movies = dataDictionary["results"] as! [[String:Any]]

                print(self.movies);
                // reload the data so that function is called
                self.tableView.reloadData()
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()

        // Do any additional setup after loading the view.
    }
    // return the movies count so that the next function runs that much time
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    // output the movie titles and cell creations
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesCell") as! MoviesCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String    // casting and look at the API and get the title
        let description = movie["overview"] as! String
    
        cell.titleLabel!.text = title
        cell.synopsisLabel!.text = description
        
        
        let baseUrl =  "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        cell.posterView.af_setImage(withURL: posterUrl!)
     return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        // Find the selected movies
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        let movie = movies[indexPath.row]
        // Pass it to the movies details to the details view controller
        
       let detailsViewController = segue.destination as! MovieDetailsAViewController
        
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    
    }
 
   

}
