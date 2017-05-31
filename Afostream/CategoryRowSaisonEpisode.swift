//
//  CategoryRowSaisonEpisode.swift
//  Afostream
//
//  Created by Bahri on 31/05/2017.
//  Copyright © 2017 Bahri. All rights reserved.
//

import UIKit



class CategoryRowSaisonEpisode : UITableViewCell {
    
    var Movies = [MovieModel]()
    var myViewController: MovieDetailsViewController!
    
}

extension CategoryRowSaisonEpisode : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "videoCell", for: indexPath) as! VideoCell
        cell.imgMovie.sd_setImage(with: URL(string: Movies[indexPath.row].imageUrl), placeholderImage:#imageLiteral(resourceName: "FanartPlaceholderSmall"))
        cell.lblTitle.text = Movies[indexPath.row].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = Movies[indexPath.row].title
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as! MovieDetailsViewController
        vc.title = title
        vc.Movie =  Movies[indexPath.row]
        myViewController.navigationItem.title = ""
        myViewController.navigationController?.pushViewController(vc,animated: true)
        
    }
}

extension CategoryRowSaisonEpisode : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        // let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        //let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        
        let itemWidth = 200 - hardCodedPadding
        let itemHeight = 150 - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
