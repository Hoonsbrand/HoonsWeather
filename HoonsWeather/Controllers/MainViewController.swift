//
//  ViewController.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit
import RxSwift

final class MainViewController: UIViewController {
    
    
    // MARK: - Properties
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // searchController
    private let searchController = UISearchController(searchResultsController: SearchCityResultsController())
    
    // 현재 위치 날씨 View
    private let currentLocationWeatherView = CurrentLocationWeatherView()
  
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureScrollView()
        configureSearchController()
    }
    
    // MARK: - Helpers
    
    /// ScrollView UI 설정
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        scrollView.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.snp.makeConstraints {
            $0.centerX.equalTo(scrollView)
        }
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
        dump(searchController.searchBar.text)
    }
}
