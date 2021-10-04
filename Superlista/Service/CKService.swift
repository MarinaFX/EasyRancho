//
//  CKService.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 04/10/21.
//

import Foundation
import CloudKit

class CKServices: ObservableObject {
    
    enum UserStatus {
        case available, noAccount, couldNotDetermine, restricted, none
    }
    
    // MARK: - iCloud Info
    let container: CKContainer
    let publicDB: CKDatabase // Lists
    let privateDB: CKDatabase // Users
    
    // MARK: - Properties
    private(set) var user: UserModel?
    
    static var currentModel = CKServices()
    
    private init() {
        container = CKContainer.default()
        publicDB = container.publicCloudDatabase
        privateDB = container.privateCloudDatabase
    }
    
    // MARK: - Refresh
    @objc func refresh(_ completion: @escaping (Error?) -> Void) {
        var userStatus: UserStatus = .none
        
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        self.verifyAccount { status in
            userStatus = status
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        if userStatus == .available {
            getUser { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    completion(error)
                }
                dispatchSemaphore.signal()
            }
        }
    
    }
    
    // MARK: - Verify Account
    private func verifyAccount(completion: @escaping (UserStatus) -> Void) {
        container.accountStatus { status, error in
            if let _ = error {
                completion(.none)
            } else {
                let userStatus = self.parseCKAccountStatus(status: status)
                completion(userStatus)
            }
        }
    }
    
    // MARK: - Account Status
    private func parseCKAccountStatus(status: CKAccountStatus) -> UserStatus {
        switch status {
        case .available:
            return .available
        case .noAccount:
            return .noAccount
        case .couldNotDetermine:
            return .couldNotDetermine
        case .restricted:
            return .restricted
        default:
            return .none
        }
    }
    
    // MARK: - Get User
    private func getUser(completion: @escaping (Result<UserModel,CKError>) -> Void ) {
        let dispatchSemaphore = DispatchSemaphore(value: 1)
        dispatchSemaphore.wait()
        
        var recordID: CKRecord.ID?
        
        self.container.fetchUserRecordID { cloudRecordID, error in
            guard let localRecordID = cloudRecordID else {
                let ckError = error as? CKError
                completion(.failure(ckError ?? CKError(.internalError)))
                dispatchSemaphore.signal()
                return
            }
            recordID = localRecordID
            dispatchSemaphore.signal()
        }
        
        dispatchSemaphore.wait()
        
        guard let recordID = recordID else {
            completion(.failure(CKError(.internalError)))
            dispatchSemaphore.signal()
            return
        }
        
        self.publicDB.fetch(withRecordID: recordID) { record, error in
            guard let record = record, error == nil else {
                let ckerror = error as? CKError
                completion(.failure(ckerror ?? CKError(.internalError)))
                dispatchSemaphore.signal()
                return
            }
            let user = UserModel(record: record)
            completion(.success(user))
            dispatchSemaphore.signal()
        }
    }
    
    
}
