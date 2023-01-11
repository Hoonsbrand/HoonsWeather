//
//  SearchBarController.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import RxCocoa
import RxSwift

class SearchBarController: UIViewController {
    
    // MARK: - Properties
    
    // 도시 목록을 받아올 변수
    var allCityList: CityList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var shownCityList = CityList()
    
    // dispose: 메모리의 효율성을 위해 구독을 취소하는 메서드
    // diposeBag: 한 번에 모든 Observer를 지우기 위한 Dispose 가방
    private let disposeBag = DisposeBag()
    
    // TableView 생성 & Cell 등록
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)
        return tableView
    }()
    
    // UISearchBar
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "도시(나라) 검색"
        searchBar.isUserInteractionEnabled = true
        searchBar.barTintColor = #colorLiteral(red: 0.592104733, green: 0.7015268207, blue: 0.8401067257, alpha: 1)
        return searchBar
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        fetchCityList()
        configureTableView()
        input()
    }
    
    // MARK: - Helpers
    
    /// TableView Delegate&DataSource, rowHeight 설정
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 80
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
    }
    
    /// 도시 목록 fetching
    private func fetchCityList() {
        CityListService.shared.fetchCityList { cityList in
            self.allCityList = cityList
        }
    }
}
    

// MARK: - UITableView Delegate & DataSource

extension SearchBarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
        
        cell.cityName.text = shownCityList[indexPath.row].name
        cell.countryName.text = shownCityList[indexPath.row].country
    
        return cell
    }
}

extension SearchBarController: UISearchBarDelegate {
    
}

extension SearchBarController {
    private func input() {
        searchBar
            .rx.text    // RxCocoa의 Observable 속성
            .orEmpty    // 옵셔널이 아니도록 만듬
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인
            .subscribe(onNext: { [unowned self] query in
                guard let allCityList = allCityList else { return }
                
                // 대소문자 구분없이 필터
                self.shownCityList = allCityList.filter { $0.country.lowercased().hasPrefix(query.lowercased()) ||
                                                           $0.name.lowercased().hasPrefix(query.lowercased()) }
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}
