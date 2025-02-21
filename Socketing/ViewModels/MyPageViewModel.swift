//
//  MyPageViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/29.
//

import Foundation

enum UserMenu: String, CaseIterable {
    case MyProfile = "나의 프로필"
    case MyTickets = "나의 예매 내역"
    case Logout = "로그아웃"
    case DeleteAccount = "회원 탈퇴"
    
    var intValue: Int {
        switch self {
        case .MyProfile:
            return 0
        case .MyTickets:
            return 1
        case .Logout:
            return 2
        case .DeleteAccount:
            return 3
        }
    }
}

class MyPageViewModel {
    
    let data = UserMenu.allCases.map { $0.rawValue }
    
    func deleteUser(completionHandler: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            print("Can't find userId")
            return
        }
        APIClient.shared.deleteRequest(urlString: APIEndpoint.users.url+userId) { result in
            switch result {
            case .success(_):
                UserDefaults.standard.removeObject(forKey: "authToken")
                UserDefaults.standard.removeObject(forKey: "entranceToken")
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
                print("회원 탈퇴 실패: \(error.localizedDescription)")
            }
        }
    }
}
