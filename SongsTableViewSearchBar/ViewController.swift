//
//  ViewController.swift
//  SongsTableViewSearchBar
//
//  Created by C4Q  on 11/6/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let songs = Song.loveSongs
    
    
    var songSearchResults: [Song] {
        get {
            guard let searchString = searchString else {
                return songs
            }
            guard searchString != "" else {
                return songs
            }
            
            if let scopeTitles = songSearchBar.scopeButtonTitles {
                let currentScopeIndex = songSearchBar.selectedScopeButtonIndex
                switch scopeTitles[currentScopeIndex] {
                case "Songs":
                    return Song.filterBySong(searchString: searchString)
                case "Artist":
                    return Song.filterByArtist(searchString: searchString)
                default:
                    return songs
                }
            }
            return songs 
        }
    }
    
    var searchString: String? = nil {
        didSet {
            self.songTableView.reloadData()
        }
    }
    
    @IBOutlet weak var songSearchBar: UISearchBar!
    
    @IBOutlet weak var songTableView: UITableView!
    

    @IBOutlet var resultNotFoundLabel: UILabel!
    
    func updateLabelFrame() {
        resultNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        resultNotFoundLabel.centerYAnchor.constraint(equalTo: songTableView.centerYAnchor).isActive = true
        resultNotFoundLabel.centerXAnchor.constraint(equalTo: songTableView.centerXAnchor).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        songTableView.dataSource = self
        songTableView.delegate = self
        songSearchBar.delegate = self
        resultNotFoundLabel.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songSearchResults.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if songSearchResults.count == 0 {
            resultNotFoundLabel.isHidden = false
            songTableView.isHidden = true
            return 0
        }
        resultNotFoundLabel.isHidden = true
        songTableView.isHidden = false
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath)
        let song = songSearchResults[indexPath.row]
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artist
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchString = searchBar.text
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}



