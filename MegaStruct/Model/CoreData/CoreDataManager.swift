//
//  CoreDataManager.swift
//  MegaStruct
//
//  Created by 김정호 on 4/23/24.
//

import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    
    // MARK: - properties
    
    static let shared: CoreDataManager = CoreDataManager()
    private init() { }
    
    // AppDelegate에 접근하기 위한 프로퍼티
    private var appDelegate: AppDelegate {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate is not accessible.")
        }
        return appDelegate
    }
        
    // CoreData의 관리 객체 컨텍스트
    private var managedContext: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    let modelName: String = "Search"
    
    // MARK: - methods
    
    // 영화 정보 저장
    func saveMovie(title: String, showDate: Date, showTime: Date, price: String) {
        // CoreData에서 사용할 엔티티 생성
        let entity = NSEntityDescription.entity(forEntityName: "MyMovie", in: managedContext)!
        let movie = NSManagedObject(entity: entity, insertInto: managedContext)

        movie.setValue(title, forKeyPath: "title")
        movie.setValue(showDate, forKeyPath: "showDate")
        movie.setValue(showTime, forKeyPath: "showTime")
        movie.setValue(price, forKeyPath: "price")
           
        // 변경사항 저장
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
        
    // 영화 정보 가져오기
    func fetchMovies() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyMovie")
        
        do {
            let movies = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            return movies
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return []
        }
    }
    
    //저장된 영화 정보 삭제
    func deleteMovie(movie: NSManagedObject) {
        managedContext.delete(movie)
        do {
            try managedContext.save()
            print("예매가 취소되었습니다.")
        } catch let error as NSError {
            print("예매 취소 실패: \(error), \(error.userInfo)")
        }
    }
    
    //최근검색어 조회
    func fetchSearchData() -> [NSManagedObject] {
        do {
            let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
            let products = try managedContext.fetch(fetchRequest)
            return products
           } catch {
               print("Error fetching data: \(error)")
               return []
        }
    }
    
    //최근검색어 저장
    func saveRecentSearch(idx: Int, keyword: String, completion: @escaping (Bool) -> Void){
        guard let entity = NSEntityDescription.entity(forEntityName: modelName, in: managedContext)
                else { return }
        
        if let search: Search = NSManagedObject(entity: entity, insertInto: managedContext) as? Search {
            search.keyword = keyword
            
            do {
                try managedContext.save()
                completion(true)
            } catch {
                print("저장안됨")
                completion(false)
            }
        }
    }
    
    //word인 검색어 삭제
    func delSearchData(word: String, completion: @escaping (Bool) -> Void) {
        let request = Search.fetchRequest()

        do {
            let words = try managedContext.fetch(request)
            let filteredWords = words.filter({ $0.keyword == word })

            for filteredWord in filteredWords {
                managedContext.delete(filteredWord)
            }
            try managedContext.save()
            completion(true)
        } catch {
            print("삭제안됨")
            completion(false)
        }
    }
    
    // 사용자 정보 가져오기
    func fetchUserData(forUserId userId: String) -> User? {
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        // 해당 사용자의 ID와 일치하는 데이터를 가져오기
        fetchRequest.predicate = NSPredicate(format: "id == %@", userId)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first // 해당 ID를 가진 사용자의 정보를 반환
        } catch let error as NSError {
            print("Could not fetch user data")
            return nil
        }
    }
}
