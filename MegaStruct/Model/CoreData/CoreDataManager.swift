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
}
