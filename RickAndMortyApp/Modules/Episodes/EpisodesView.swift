//
//  EpisodesView.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

class EpisodesView: UIViewController {
    private let viewModel = EpisodesViewModel()
    private var previousSearchText: String = ""
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(EpisodesTableViewCell.self, forCellReuseIdentifier: EpisodesTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var notFoundLabel: UILabel = {
       let label = UILabel()
        label.text = "No se enontraron resultados"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        self.navigationItem.searchController = searchBar
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        previousSearchText = searchBar.searchBar.text ?? ""
        viewModel.delegate = self
        viewModel.getEpisodes()
        setupUIElements()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                if ((self?.tableView.isHidden) != nil) {
                    self?.tableView.isHidden = false
                    self?.notFoundLabel.isHidden = true
                }
            }
        }
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(tableView)
        view.addSubview(notFoundLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            notFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension EpisodesView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EpisodesTableViewCell.identifier, for: indexPath) as? EpisodesTableViewCell {
            cell.backgroundColor = indexPath.row % 2 == 0 ? .systemBackground : .secondarySystemBackground
            cell.setCell(episodes: viewModel.episodes[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

extension EpisodesView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let currentSearchText = searchController.searchBar.text else {
            return
        }
        
        if currentSearchText != previousSearchText {
            viewModel.getFilterEpisodes(searchText: currentSearchText)
            previousSearchText = currentSearchText
        }
    }
}

extension EpisodesView: EpisodesViewModelDelegate {
    func notifyNotFoundEpisodes() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = true
            self?.notFoundLabel.isHidden = false
        }
    }
}
