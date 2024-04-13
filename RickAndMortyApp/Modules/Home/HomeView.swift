//
//  HomeView.swift
//  RickAndMortyApp
//
//  Created by Luis Fernando Sánchez Palma on 12/04/24.
//

import UIKit

class HomeView: UIViewController {
    
    lazy var buttonStackContainer : UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        stack.contentMode = .scaleAspectFit
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var charactersButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Characters", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToCharactersView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var episodesButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Episodes", for: .normal)
        button.layer.cornerRadius = 25
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(goToEpisodesView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        setupUIElements()
        setupConstraints()
    }
    
    fileprivate func setupUIElements() {
        view.addSubview(buttonStackContainer)
        buttonStackContainer.addArrangedSubview(charactersButton)
        buttonStackContainer.addArrangedSubview(episodesButton)
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonStackContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            buttonStackContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            buttonStackContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            charactersButton.heightAnchor.constraint(equalToConstant: 50),
            episodesButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func goToCharactersView(_ sender: UIButton) {
        let charactersVC = CharactersView()
        self.navigationController?.pushViewController(charactersVC, animated: true)
    }
    
    @objc func goToEpisodesView(_ sender: UIButton) {
        let episodesVC = EpisodesView()
        self.navigationController?.pushViewController(episodesVC, animated: true)
    }

}

