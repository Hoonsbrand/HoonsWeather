//
//  SearchBarController.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import RxCocoa
import RxSwift

// MARK: - SendDataDelegate
/// 데이터를 주고받기 위한 프로토콜 메서드
protocol SendDataDelegate {
    func recieveData(weatherData: WeatherData)
}

final class SearchBarController: UIViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    var delegate: SendDataDelegate?
    
    // 도시 목록을 받아올 변수
    var allCityList: CityList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // TableView에 동적으로 보여지는 도시 목록
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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.backButtonTitle = "취소"
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // json파일의 도시 coord에 접근해 위도와 경도를 받아 변수에 할당
        let lat = shownCityList[indexPath.row].coord.lat
        let lon = shownCityList[indexPath.row].coord.lon
        
        // Alamofire를 위도와 경도를 이용해 호출하여 해당 지역의 날씨 전체 정보를 받아옴
        AlamofireManger.shared.fetchCurrentTempWithLatAndLon(inputLat: lat, inputLon: lon) { weather in
            // 받은 날씨 정보를 프로토콜 메서드를 통해 넘겨줌
            self.delegate?.recieveData(weatherData: weather)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - RxSwift를 이용한 SearchBar와 TableView간 소통
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
