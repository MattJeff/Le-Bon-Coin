//
//  AnonceViewModel.swift
//  autolayout
//
//  Created by Mathis Higuinen on 28/09/2022.
//

import Foundation
import UIKit
import Combine



class AnonceViewModel:ObservableObject {
    
    @Published var anonce:[AnonceElement] = []
    @Published var categorie:[CategorieElement] = []
    var cancellables = Set<AnyCancellable>()
      
    var hasAnonce:Bool{
        return !anonce.isEmpty
    }
    var hasCetegorie:Bool{
        return !categorie.isEmpty
    }
    
    init(){
        getCategorye{ succes in
            
            print(succes ? "DEBUG: CALL API CETGORIE CONTAINS DATA: SUCCES " : "DEBUG ERRRU: CALL API CONTAINTS DATA FAILD ")
            
        }
        fetchAnonce{ succes in
            print(succes ? "DEBUG: CALL API: SUCCES " : "DEBUG ERRRU: CALL API FAILD ")
        }
    }
    
    func getAnonceByCat(catId:Int)->[AnonceElement]{
      
        return self.anonce.filter { $0.categoryID == catId }
        
    }

    func fetchAnonce(onSucces:@escaping(Bool) -> Void){
        
        guard let  url = URL(string:baseUrl) else{return}
        
       URLSession.shared.dataTaskPublisher(for: url)
                   .receive(on: DispatchQueue.main)
                   .tryMap({ (data, response) -> Data in
                       guard
                           let response = response as? HTTPURLResponse,
                           response.statusCode >= 200 else {
                           throw URLError(.badServerResponse)
                       }
                       if data != nil {
                           onSucces(true)
                           print(String(data:data,encoding: .utf8))
                       }else{
                           onSucces(false)
                       }
                       return data
                   })
                   .decode(type: [AnonceElement].self, decoder: JSONDecoder())
                   .flatMap({ (anonce) -> AnyPublisher<AnonceElement, Error> in
                       Publishers.Sequence(sequence: anonce).eraseToAnyPublisher()
                   })
                   .collect()
                   .sink(receiveCompletion: { (completion) in
                       print("Completion:", completion)
                   }, receiveValue: { (anonces) in
                       self.anonce = anonces
                       
                   })
                   .store(in: &cancellables)
        
    }
    
    func getCategorye(onSucces:@escaping(Bool)->Void){
        guard let  url = URL(string:baseUrlCategorie) else{return}
        
       URLSession.shared.dataTaskPublisher(for: url)
                   .receive(on: DispatchQueue.main)
                   .tryMap({ (data, response) -> Data in
                       guard
                           let response = response as? HTTPURLResponse,
                           response.statusCode >= 200 else {
                           throw URLError(.badServerResponse)
                       }
                       
                       if data != nil {
                           onSucces(true)
                           print(String(data:data,encoding: .utf8))
                       }else{
                           onSucces(false)
                       }
                       
                       return data
                   })
                   .decode(type: [CategorieElement].self, decoder: JSONDecoder())
                   .flatMap({ (categorie) -> AnyPublisher<CategorieElement, Error> in
                       Publishers.Sequence(sequence: categorie).eraseToAnyPublisher()
                   })
                   .collect()
                   .sink(receiveCompletion: { (completion) in
                       print("Completion:", completion)
                   }, receiveValue: { (categories) in
                       self.categorie = categories
                       
                   })
                   .store(in: &cancellables)
    }
    

    
}
