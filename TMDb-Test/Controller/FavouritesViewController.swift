//
//  FavouritesViewController.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 27/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var storedArray: Results<MovieObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        tableView.delegate = self
        tableView.dataSource = self
    
        do {
            let realm = try Realm()
            let stored = realm.objects(MovieObject.self)
            storedArray = stored
        } catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func configureView(){
        view.backgroundColor = UIColor.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.textColor
        tableView.backgroundColor = UIColor.backgroundColor
    }
    
    // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if storedArray != nil {
            return (storedArray?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.backgroundColor
        cell.selectionStyle = .none
        
        if let movie = storedArray?[indexPath.row] {
            cell.textLabel?.text = "\(movie.title)"
            cell.detailTextLabel?.text = "Released: \(movie.release_date.toDate())"
        }
        
        cell.textLabel?.textColor = UIColor.textColor
        cell.textLabel?.backgroundColor = UIColor.backgroundColor
        cell.detailTextLabel?.textColor = UIColor.textColor
        cell.detailTextLabel?.backgroundColor = UIColor.backgroundColor
        cell.contentView.backgroundColor = UIColor.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
                let realm = try Realm()
                let object = realm.objects(MovieObject.self)
                try realm.write {
                    realm.delete(object[indexPath.row])
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavDetails" {
            if let index = tableView.indexPathForSelectedRow?.row, let storedarr = storedArray {
             let destination = segue.destination as! MovieDetailViewController
                destination.movie = TopRatedMovie(mObject: storedarr[index])
            }
        }
    }
}
