//
//  sample.swift
//  HoonsWeather
//
//  Created by hoonsbrand on 2023/01/10.
//

import UIKit
import SnapKit
import RxSwift

final class SearchCityResultsController: UITableViewController {
    
    // 도시 목록을 받아올 변수
    var cityList: CityList? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchCityList()
    }
    
    
    
    // MARK: - Helpers
    
    /// TableView 세팅
    private func configureTableView() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)
        tableView.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        tableView.rowHeight = 80
    }
    
    /// 도시 목록 fetching
    private func fetchCityList() {
        CityListService.shared.fetchCityList { cityList in
            self.cityList = cityList
        }
    }
}

// MARK: - UITableView Delegate & DataSource

extension SearchCityResultsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityCount = cityList?.count else { return 0 }
        return cityCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
        
        guard let cityName = cityList?[indexPath.row].name,
              let countryName = cityList?[indexPath.row].country else { return cell }
        
        cell.cityName.text = cityName
        cell.countryName.text = countryName
    
        return cell
    }
}

extension SearchCityResultsController {
    private func input() {
        
    }
}


