//
//  CharactersView.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

class CharactersView: UIViewController {
    private let viewModel = CharactersViewModel()
    private var previousSearchText: String = ""
    
    lazy var searchBar: UISearchController = {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier)
        return collectionView
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
        title = "Characters"
        self.navigationItem.searchController = searchBar
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        previousSearchText = searchBar.searchBar.text ?? ""
        viewModel.delegate = self
        viewModel.getCharacters()
        setupUIElements()
        setupConstraints()
        bind()
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                if ((self?.collectionView.isHidden) != nil) {
                    self?.collectionView.isHidden = false
                    self?.notFoundLabel.isHidden = true
                }
            }
        }
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(collectionView)
        view.addSubview(notFoundLabel)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            notFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension CharactersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as? CharacterCollectionViewCell {
            cell.setCell(character: viewModel.characters[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width: CGFloat
        if UIDevice.isiPhone {
            width = (bounds.width-30)/2
        } else {
            width = (bounds.width-50)/4
        }

        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
}

extension CharactersView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let currentSearchText = searchController.searchBar.text else {
            return
        }
        if currentSearchText != previousSearchText {
            viewModel.getFilterCharacters(searchText: currentSearchText)
            previousSearchText = currentSearchText
        }
    }
}

extension CharactersView: CharactersViewModelDelegate {    
    func notifyNotFoundCharacters() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.isHidden = true
            self?.notFoundLabel.isHidden = false
        }
    }
}
