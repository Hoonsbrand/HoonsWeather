//
//  ViewController.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // searchController
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var searchBar: UIView = {
        let view = UIView()
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(handleSearchBarTapped))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(viewTap)
        view.backgroundColor = .red
        return view
    }()
    
    // 현재 위치 날씨 View
    private let currentLocationWeatherView = CurrentLocationWeatherView()
  
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Helpers
    
    /// ScrollView UI 설정
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        scrollView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
        
        scrollView.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(50)
            $0.centerX.equalTo(scrollView)
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleSearchBarTapped() {
        let controller = SearchBarController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}

// MARK: - SearchBar 관련

extension MainViewController: UISearchResultsUpdating {
    /// SearchController 설정
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.automaticallyShowsCancelButton = false
    
        searchController.searchBar.placeholder = "도시 검색"
        searchController.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.592104733, green: 0.7015268207, blue: 0.8401067257, alpha: 1)
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    /// updateSearchResults
    func updateSearchResults(for searchController: UISearchController) {
        let controller = UINavigationController(rootViewController: SearchCityResultsController())
        controller.modalPresentationStyle = .fullScreen
        
        present(controller, animated: true)
    }
    
    
}
