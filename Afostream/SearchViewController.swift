//
//  SearchViewController.swift
//  Afostream
//
//  Created by Bahri on 03/07/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage


class SearchViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var MoviesList = [MovieModel]()
    
    var ListFavMovies = [MovieModel]()

    
    var laoding_spinner:UIActivityIndicatorView=UIActivityIndicatorView()
    
    lazy var searchBar = UISearchBar()
    
    func StartLoadingSpinner()
    {
        laoding_spinner.center=self.view.center
        laoding_spinner.hidesWhenStopped=true
        laoding_spinner.activityIndicatorViewStyle=UIActivityIndicatorViewStyle.gray
        self.view.addSubview(laoding_spinner)
        laoding_spinner.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func StopLoadingSpinner()
    {
        laoding_spinner.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    func ShowAlert(Title:String ,Message:String)
    {
        let alertController = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func MakeGetSearchMovies(access_token:String,KeyWord:String)
    {
        
        if access_token.isEmpty
        {
            ShowAlert(Title: NSLocalizedString("Error", comment: ""), Message: NSLocalizedString("ErrorAccessToken", comment: ""))
            return
        }
        
        let headers = [
            "Authorization": "Bearer " + GlobalVar.StaticVar.access_token
            
        ]
        
        
        
        let parameters = [
            "query": KeyWord
          
        ]

        
        
        
        self.StartLoadingSpinner()
        
        
        
        Alamofire.request(GlobalVar.StaticVar.BaseUrl + "/api/movies/search"  + GlobalVar.StaticVar.ApiUrlParams, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch(response.result) {
            case .success(_):
                
                
                
                self.StopLoadingSpinner()
                
                let dt = response.result.value as? [String: Any]
                
                
                if let JSON = dt?["hits"] as! NSArray? {
                    self.MoviesList.removeAll()
                    
                    
                    for elementMovie in JSON {
                        if let dataMovie = elementMovie as? [String: Any] {
                            
                            let movileTitle = dataMovie["title"] as! String
                            let movileLabel = dataMovie["genre"] as? String
                            
                            let movileID = dataMovie["_id"] as! Int
                            
                            
                            if let posterMovie = dataMovie ["poster"] as? [String: Any]
                            {
                                
                                var urlImageMovie = posterMovie["imgix"] as! String
                                
                                urlImageMovie = urlImageMovie + "?&crop=entropy&fit=min&w=300&h=250&q=90&fm=jpg&&auto=format&dpr=" + String(GlobalVar.StaticVar.densityPixel)
                                
                                var mov:MovieModel
                                
                               // if self.IsContainFav(idMovie: movileID)
                                //{
                                    mov = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: true,movieInfo: dataMovie)
                               // }else
                               // {
                                 //   mov = MovieModel(title: movileTitle, movieID: movileID, imageUrl: urlImageMovie, label: "", isFav: false,movieInfo: dataMovie)
                                //}
                                
                                self.MoviesList.append(mov)
                                
                            }
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    self.tableView.reloadData()
                    
                }
                
                
                
                
                
                
                
                
                
                
                break
                
            case .failure(_):
                self.StopLoadingSpinner()
                print("There is an error")
                break
            }
        }
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MoviesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SearchTableViewCell
        cell.Movie = self.MoviesList[indexPath.row]
        cell.imgMovie.sd_setImage(with: URL(string: self.MoviesList[indexPath.row].imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
        cell.lblTitle.text = self.MoviesList[indexPath.row].title
        
                
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = MoviesList[indexPath.row].title
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.title = title
        vc.Movie =  MoviesList[indexPath.row]
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc,animated: true)
        
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar

        // Do any additional setup after loading the view.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text  == ""
        {
            
        }else
        {
            self.MakeGetSearchMovies (access_token: GlobalVar.StaticVar.access_token ,  KeyWord: searchBar.text!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
