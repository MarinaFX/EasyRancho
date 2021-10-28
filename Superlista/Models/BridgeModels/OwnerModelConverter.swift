import Foundation
import CloudKit

//MARK: - OwnerModelConverter Class

/**
 OwnerModelConverter is a Bridge class converting our Cloud record/class of User arquitecture to our local/UserDefaults class arquitecture.
 
 According to its formal definition, a Bridge is something that meakes its easier to change from one situation to another. In this case, instead of refactoring the whole backend everytime we make a new implementation of a service, a Bridge class connects both arquitectures by parsing each to each. This way is possible to manipulate both strcutures without backend refactoring.
 */
class OwnerModelConverter {
    //MARK: OwnerModelConverter Functions: Reference to ☁️
    
    /**
    This method converts the CKRecord.Reference structure to our cloud CKOwnerModel structure
     
     - Parameters:
        - items: the reference to be converted
     - Returns: the CKOwnerModel version of the given reference
     */
    func convertReferenceToCK(withReference references: [CKRecord.Reference], completion: @escaping (Result<[CKOwnerModel], CKError>) -> Void) {
        var cloudOwner: [CKOwnerModel] = []
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            var ckError: CKError?
            
            for reference in references {
                group.enter()
                
                CKService.currentModel.getAnotherUser(userID: reference.recordID) { result in
                    switch result {
                    case .success(let user):
                        cloudOwner.append(user)
                    case .failure(let error):
                        ckError = error
                    }
                    group.leave()
                }
            }
            
            group.wait()
            
            if let error = ckError {
                completion(.failure(error))
            }
            else {
                completion(.success(cloudOwner))
            }
        }
    }
    
    /**
    This method converts the CKRecord.Reference structure to our cloud CKOwnerModel structure
     
     - Parameters:
        - items: the reference to be converted
     - Returns: the CKOwnerModel version of the given reference
     */
    func convertReferenceToCK(withReference reference: CKRecord.Reference, completion: @escaping (Result<CKOwnerModel, CKError>) -> Void) {
        DispatchQueue.global().async {
            CKService.currentModel.getAnotherUser(userID: reference.recordID) { result in
                switch result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    //MARK: OwnerModelConverter Functions: ☁️ to Local
    
    /**
    This method converts our current cloud CKOwnerModel structure to our local OwnerModel structure
     
     - Parameters:
        - items: the CKOwnerModel to be converted
     - Returns: the OwnerModel version of the given CKOwnerModel
     */
    func convertCKOwnerToLocal(withUser user: CKOwnerModel) -> OwnerModel {
        return OwnerModel(id: user.id.recordName, name: user.name ?? "OwnerName")
    }
    
    //MARK: OwnerModelConverter Functions: Local to ☁️
    
    /**
    This method converts our current cloud OwnerModel structure to our local CKOwnerModel structure
     
     - Parameters:
        - items: the OwnerModel to be converted
     - Returns: the CKOwnerModel version of the given OwnerModel
     */
    func convertLocalToCKOwner(withUser user: OwnerModel) -> CKOwnerModel {
        return CKOwnerModel(id: CKRecord.ID(recordName: user.id), name: user.name ?? "OwnerName") 
    }
}
