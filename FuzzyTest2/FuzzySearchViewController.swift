//
//  FuzzySearchViewController.swift
//  Fuzzy Test
//
//  Created by Michael Isasi on 1/13/20.
//  Copyright © 2020 Michael Isasi. All rights reserved.
//

import UIKit

class FuzzySearchViewController: UIViewController {
    
    private struct Const {
        public static let cellName = "ArtistCell"
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var artistTableView: UITableView!
    @IBOutlet weak var toloranceSlider: UISlider!
    
    private var viewModel: ArtistViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ArtistViewModel()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateFilter(_ sender: UISegmentedControl) {
        self.viewModel.update(filter: sender.selectedSegmentIndex)
        self.toloranceSlider.isHidden = sender.selectedSegmentIndex == 0
        self.artistTableView.reloadData()
    }
    
    @IBAction func updateRestrictions(_ sender: UISegmentedControl) {
        self.viewModel.toggleSpec()
        self.artistTableView.reloadData()
    }
    
    @IBAction func updateTolorance(_ sender: UISlider) {
        let value = Int(sender.value)
        self.viewModel.update(tolorance: value)
        self.artistTableView.reloadData()
    }
}

extension FuzzySearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.artistCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellName) else { fatalError() }
        cell.textLabel?.text = self.viewModel.artist(for: indexPath.row)
        return cell
    }
}

extension FuzzySearchViewController: UITableViewDelegate {
}

extension FuzzySearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.update(searchText: searchText)
        self.artistTableView.reloadData()
    }
}
