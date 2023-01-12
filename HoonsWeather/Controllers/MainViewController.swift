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
    
    // viewModel에 새로운 값이 들어오면 CollectionView를 reload
    var viewModel: SelectedWeatherViewModel? {
        didSet {
            threeHourWeatherCollectionView.reloadData()
        }
    }
    
    var weather: WeatherData?
    
    // 전체 뷰를 관장할 scrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    // 도시 검색 화면으로 넘어갈 Button
    private lazy var searchBar: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSearchBarTapped), for: .touchUpInside)
        button.setImage(UIImage(systemName: "magnifyingglass.circle.fill"), for: .normal)
        button.tintColor = .white
        button.setTitle(" 도시(나라) 검색", for: .normal)
        return button
    }()
    
    // 3시간 간격 날씨를 보여주는 CollectionView
    private let threeHourWeatherCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        cv.register(FutureTwoDaysWeatherCell.self, forCellWithReuseIdentifier: FutureTwoDaysWeatherCell.reuseIdentifier)
        cv.snp.makeConstraints { $0.height.equalTo(100) }
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    // 최대 풍속을 알려주는 label
    private let maxWindSpeedLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    // threeHourWeatherCollectionView와 maxWindSpeedLabel 사이의 구분선
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.4353573918, green: 0.5798597336, blue: 0.7632742524, alpha: 1)
        view.snp.makeConstraints {
            $0.height.equalTo(1.0)
        }
        return view
    }()
    
    // maxWindSpeedLabel, divider, threeHourWeatherCollectionView를 담는 View
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2996364236, green: 0.4886600375, blue: 0.735879004, alpha: 1)
        view.layer.cornerRadius = 20
        return view
    }()
    
    // 최상단에 위치하는 현재 위치 날씨 View
    private let currentLocationWeatherView = SelectedWeatherView()
    
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
        scrollView.isScrollEnabled = true
        setCurrentWeatherView()
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = #colorLiteral(red: 0.4146796465, green: 0.5725354552, blue: 0.7671923041, alpha: 1)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        
        configureSearchBar()
        configureCurrentLocationWeatherView()
        configureThreeHourCollectionView()
    }
    
    /// SearchBar UI 세팅
    private func configureSearchBar() {
        scrollView.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        }
    }
    
    /// currentLocationWeatherView UI 세팅
    private func configureCurrentLocationWeatherView() {
        scrollView.addSubview(currentLocationWeatherView)
        currentLocationWeatherView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.centerX.equalTo(scrollView)
        }
    }
    
    /// CollectionView UI 세팅
    private func configureThreeHourCollectionView() {
        threeHourWeatherCollectionView.delegate = self
        threeHourWeatherCollectionView.dataSource = self
        
        let stack = UIStackView(arrangedSubviews: [maxWindSpeedLabel, divider, threeHourWeatherCollectionView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fill
        
        scrollView.addSubview(containerView)
        containerView.addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.top.left.equalTo(containerView).offset(10)
            $0.bottom.right.equalTo(containerView).offset(-10)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(currentLocationWeatherView.snp.bottom).offset(50)
            $0.width.equalTo(scrollView).offset(-50)
            $0.height.equalTo(150)
            $0.centerX.equalTo(scrollView)
        }
    }
    
    /// 최근 날씨 View 설정
    private func setCurrentWeatherView() {
        AlamofireManger.shared.fetchCurrentTempWithLatAndLon() { weather in
            let viewModel = SelectedWeatherViewModel(weatherData: weather)
            // 날씨 데이터를 받아올 때 멤버변수 viewModel에 할당을 해줌으로써 다른곳에서도 사용이 가능케함
            self.viewModel = viewModel
            self.setCurrentWeatherLabelWithViewModel(viewModel: viewModel)
        }
    }
    
    /// ViewModel을 이용해 Label에 값 할당
    private func setCurrentWeatherLabelWithViewModel(viewModel: SelectedWeatherViewModel) {
        self.currentLocationWeatherView.cityLabel.text = viewModel.cityname
        self.currentLocationWeatherView.temperatureLabel.text = viewModel.temperature
        self.currentLocationWeatherView.weatherDescribeLabel.text = viewModel.weatherDescription
        self.currentLocationWeatherView.maximumMinimumTempLabel.text = viewModel.minMaxTemp
        
        self.maxWindSpeedLabel.text = "돌풍의 풍속은 최대 \(viewModel.maxSpeed)m/s 입니다."
    }
    
    
    // MARK: - Selectors
    
    /// 검색 화면으로 이동
    @objc func handleSearchBarTapped() {
        let controller = SearchBarController()
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SendDataDelegate

extension MainViewController: SendDataDelegate {
    func recieveData(weatherData: WeatherData) {
        let viewModel = SelectedWeatherViewModel(weatherData: weatherData)
        setCurrentWeatherLabelWithViewModel(viewModel: viewModel)
        self.viewModel = viewModel
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.threeHourTemp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FutureTwoDaysWeatherCell.reuseIdentifier, for: indexPath) as! FutureTwoDaysWeatherCell
        guard let viewModel = viewModel else { return cell }
        
        cell.timeLabel.text = viewModel.weatherTime[indexPath.row]
        
        cell.tempLabel.text = viewModel.threeHourTemp[indexPath.row]
        cell.weatherImage.image = UIImage(named: viewModel.conditionName[indexPath.row])

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize() }
        
        let itemSize = CGSize(width: 45, height: 100)
        
        return itemSize
        //        return CGSize(width: 80, height: threeHourWeatherCollectionView.frame.height)
    }
}

