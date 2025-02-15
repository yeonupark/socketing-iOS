//
//  MyPageViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/01/29.
//

import Foundation

class MyPageViewModel {
    
    let data = ["로그아웃", "회원 탈퇴"]
    
    func deleteUser(completionHandler: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            print("Can't find userId")
            return
        }
        APIClient.shared.deleteRequest(urlString: APIEndpoint.users.url+userId) { result in
            switch result {
            case .success(_):
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
                print("회원 탈퇴 실패: \(error.localizedDescription)")
            }
        }
    }
}
