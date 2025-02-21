//
//  MyProfileViewModel.swift
//  Socketing
//
//  Created by Yeonu Park on 2025/02/21.
//

import Foundation
import RxCocoa
import UIKit

class MyProfileViewModel {
    
    let nickname = BehaviorRelay(value: "")
    let submitButtonEnabled: Driver<Bool>
    let submitButtonColor: Driver<UIColor>
    
    init() {
        
        submitButtonEnabled = nickname
            .map { !$0.replacingOccurrences(of: " ", with: "").isEmpty && $0.replacingOccurrences(of: " ", with: "") != UserDefaults.standard.string(forKey: "nickname") }
            .asDriver(onErrorJustReturn: false)
        
        submitButtonColor = submitButtonEnabled
            .map { isEnabled in
                return isEnabled ? UIColor.systemPink : UIColor.lightGray
            }
            .asDriver(onErrorJustReturn: UIColor.lightGray)
    }
    
    func updateNickname(completionHandler: @escaping (Bool) -> Void) {
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return
        }
        let url = "\(APIEndpoint.users.url)\(userId)/nickname"
        let nicknameRequest = NicknameUpdateRequest(nickname: nickname.value.replacingOccurrences(of: " ", with: ""))
        APIClient.shared.patchRequest(urlString: url, requestBody: nicknameRequest, responseType: UserResponse.self) { result in
            switch result {
            case .success(let response):
                UserDefaults.standard.setValue(response.data?.nickname, forKey: "nickname")
                completionHandler(true)
            case .failure(let error):
                completionHandler(false)
                print("닉네임 변경 실패: \(error.localizedDescription)")
            }
        }
    }
}
