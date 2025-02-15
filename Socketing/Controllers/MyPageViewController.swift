//
//  MyPageViewController.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/29. 
//

import UIKit

class MyPageViewController: BaseViewController {
    
    let mainView = MyPageView()
    let viewModel = MyPageViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
        configureNavigationBar()
        
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "마이페이지"
    }
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        cell.textLabel?.text = viewModel.data[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        
        if indexPath.row == 1 {
            cell.textLabel?.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.removeObject(forKey: "entranceToken")
            let vc = MainViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
        else if indexPath.row == 1 {
            let alert = UIAlertController(title: "정말 탈퇴하시겠습니까?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
            alert.addAction(UIAlertAction(title: "네", style: .destructive, handler: { _ in
                self.viewModel.deleteUser { done in
                    DispatchQueue.main.async {
                        if done {
                            UserDefaults.standard.removeObject(forKey: "authToken")
                            UserDefaults.standard.removeObject(forKey: "entranceToken")
                            let vc = MainViewController()
                            self.navigationController?.setViewControllers([vc], animated: true)
                        } else {
                            let failedAlert = UIAlertController(title: "탈퇴 실패하였습니다.", message: nil, preferredStyle: .alert)
                            failedAlert.addAction(UIAlertAction(title: "확인", style: .default))
                            self.present(failedAlert, animated: true)
                        }
                    }
                }
            }))
            self.present(alert, animated: true)
        }
        mainView.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
