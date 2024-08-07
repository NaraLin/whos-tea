//
//  DrinkOrderViewController.swift
//  whos tea
//
//  Created by 林靖芳 on 2024/7/1.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class DrinkOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let viewModel: DrinkOrderViewModel
    
    init(viewModel: DrinkOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "mainColor")
        headerView.isUserInteractionEnabled = false
        
        let headerLabel = UILabel()
        headerLabel.text = orderSection.allCases[section].rawValue
        headerLabel.textColor = .white
        headerLabel.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 24)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])
        
        return headerView
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
            case 0:
                return 1
            case 1:
                return iceChoice.allCases.count
            case 2:
                return sugarChoice.allCases.count
            default :
                return 1
                
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.updateSelectOption(section: indexPath.section, row: indexPath.row)
        //viewModel.selectOption[indexPath.section] = indexPath.row
        
        //更新指定的section
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let iceSugarCell = tableView.dequeueReusableCell(withIdentifier: "iceAndSugarCell", for: indexPath) as! IceSugarTableViewCell
        
        let drinkCell = tableView.dequeueReusableCell(withIdentifier: "drinkCell", for: indexPath) as! OrderDrinkTableViewCell
        
        
        tableView.separatorStyle = .none
        
        iceSugarCell.radioButton.isSelected = viewModel.isOptionSelected(section: indexPath.section, row: indexPath.row)
        
        switch indexPath.section {
            case 0:
                drinkCell.drinkLabel.text = viewModel.drinks.fields.name
                drinkCell.drinkImageView.image = viewModel.image
                drinkCell.isUserInteractionEnabled = false
                
                return drinkCell
                
            case 1:
                iceSugarCell.iceSugarLabel.text = iceChoice.allCases[indexPath.row].rawValue
                return iceSugarCell
                
            case 2:
                iceSugarCell.iceSugarLabel.text = sugarChoice.allCases[indexPath.row].rawValue
                return iceSugarCell
                
                
            default:
                return iceSugarCell
        }
        
    }
    
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        
        //registercell
        tableview.register(IceSugarTableViewCell.self, forCellReuseIdentifier: "iceAndSugarCell")
        tableview.register(OrderDrinkTableViewCell.self, forCellReuseIdentifier: "drinkCell")
        
        //delegate
        tableview.dataSource = self
        tableview.delegate = self
        
        return tableview
    }()
    
    
    private lazy var qtyStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .fill
        view.spacing = 16
        return view
        
    }()
    
    private lazy var priceStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 4
        return view
        
    }()
    
    private lazy var cartLeftStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .leading
        view.spacing = 12
        return view
        
    }()
    
    private lazy var cartStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "mainColor")
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8
        
        return view
        
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "總金額 ：＄"
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.textColor = .white
        
        return label
    }()
    
    //使用lazy來宣告變數，表示該變數的初始化會延遲到第一次被存取時才執行。這樣可以節省記憶體和提高效能，特別是在初始化過程中需要進行一些計算或需要存取其他物件的情況下使用
    private lazy var selectPriceLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.drinks.fields.largeSizePrice
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        label.textColor = .yellow
        
        return label
    }()
    
    private lazy var QTYLabel: UILabel = {
        let label = UILabel()
        label.text = "數量 ："
        label.font = UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)
        label.textColor = .white
        
        return label
    }()
    
   private lazy var selectQTYLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont(name: "GillSans-SemiBold", size: 24)
        label.textColor = .yellow
        
        return label
    }()
    
    private lazy var QTYStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.stepValue = 1
        stepper.minimumValue = 1
        stepper.value = 1
        stepper.backgroundColor = UIColor.white
        stepper.layer.cornerRadius = 12
        stepper.clipsToBounds = true
        stepper.addTarget(self, action: #selector(stepperValueChange), for: .valueChanged)
        return stepper
        
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        // button.setTitle("加到購物車", for: .normal)
        let normalAttributedString: [NSAttributedString.Key : Any] = [.font : UIFont(name: "NatsuzemiMaruGothic-Black", size: 20)!, .foregroundColor : UIColor.white]
        button.setAttributedTitle(NSAttributedString(string: "加到購物車", attributes: normalAttributedString), for: .normal)
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setup UI
        setupUI()
        
        
        //取得用戶名
        viewModel.getCurrentUser()
        
        //addTarget
        
        
        
        setupBinding()
        viewModel.updatePrice()
    }
    
    
    private func setupUI(){
        
        let footerView = UIView()
        footerView.addSubview(cartStackView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = UIColor(named: "mainColor")
        
        //subview
        view.addSubview(tableView)
        view.addSubview(footerView)
        
        qtyStackView.addArrangedSubview(QTYLabel)
        qtyStackView.addArrangedSubview(selectQTYLabel)
        qtyStackView.addArrangedSubview(QTYStepper)
        
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(selectPriceLabel)
        
        cartLeftStackView.addArrangedSubview(qtyStackView)
        cartLeftStackView.addArrangedSubview(priceStackView)
        
        cartStackView.addArrangedSubview(cartLeftStackView)
        cartStackView.addArrangedSubview(addToCartButton)
        
        
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.heightAnchor.constraint(equalToConstant: 120),
            footerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            cartStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            cartStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            cartStackView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            
            
        ])
        
    }
    
    private func setupBinding() {
        
        
        //定義viewModel closure
        viewModel.onQtyUpdated = { [weak self] qty in
            self?.selectQTYLabel.text = "\(qty)"
        }
        
        viewModel.onPriceUpdated = { [weak self] price in
            self?.selectPriceLabel.text = "\(price)"
        }
    }
    
    
    @objc func stepperValueChange(sender: UIStepper) {
        viewModel.updateQty(value: Int(sender.value))
    }
    
    
    
    @objc func addToCart() {
        
        viewModel.addToCart { [weak self] result in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                    case .success:
                        strongSelf.viewModel.uploadCartOrder { result in
                            DispatchQueue.main.async {
                                switch result {
                                    case .success:
                                        strongSelf.showAlert(title: "已成功加入購物車", message: "")
                                    case .failure(let error):
                                        strongSelf.showAlert(title: "Error", message: error.localizedDescription)
                                }
                            }
                        }
                    case .failure(let error):
                        strongSelf.showAlert(title: "\(error.message)", message: "")
                }
            }
            
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

