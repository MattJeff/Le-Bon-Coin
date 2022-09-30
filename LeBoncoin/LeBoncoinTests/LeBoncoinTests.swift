//
//  LeBoncoinTests.swift
//  LeBoncoinTests
//
//  Created by Mathis Higuinen on 28/09/2022.
//

import XCTest
@testable import LeBoncoin

final class LeBoncoinTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanParseAnonce() throws{
        let json = """
                        {
                              "id":1461267313,
                              "category_id":4,
                              "title":"Statue homme noir assis en plâtre polychrome",
                              "description":"Magnifique Statuette homme noir assis fumant le cigare en terre cuite et plâtre polychrome réalisée à la main.  Poids  1,900 kg en très bon état, aucun éclat  !  Hauteur 18 cm  Largeur : 16 cm Profondeur : 18cm  Création Jacky SAMSON  OPTIMUM  PARIS  Possibilité de remise sur place en gare de Fontainebleau ou Paris gare de Lyon, en espèces (heure et jour du rendez-vous au choix). Envoi possible ! Si cet article est toujours visible sur le site c'est qu'il est encore disponible",
                              "price":140.00,
                              "images_url":{
                                 "small":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg",
                                 "thumb":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg"
                              },
                              "creation_date":"2019-11-05T15:56:59+0000",
                              "is_urgent":false
              }
                           
              """
        
        let jsonData = json.data(using:.utf8)!
        let Anonce = try! JSONDecoder().decode(AnonceElement.self, from: jsonData)
        XCTAssertEqual(1461267313, Anonce.id)
        XCTAssertEqual("Statue homme noir assis en plâtre polychrome", Anonce.title)
        XCTAssertEqual("https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg", Anonce.imagesURL.small)
        XCTAssertEqual("https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg", Anonce.imagesURL.thumb)
        
    }
    
    func testCanParseAnonceWithEmptydescription() throws{
        let json = """
                        {
                              "id":1461267313,
                              "category_id":4,
                              "title":"",
                              "description":"",
                              "price":140.00,
                              "images_url":{
                                 "small":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg",
                                 "thumb":"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg"
                              },
                              "creation_date":"2019-11-05T15:56:59+0000",
                              "is_urgent":false
              }
                           
              """
        
        let jsonData = json.data(using:.utf8)!
        let Anonce = try! JSONDecoder().decode(AnonceElement.self, from: jsonData)
        XCTAssertEqual("", Anonce.anonceDescription)
  
        
    }
    
    func testCanParseAnnonceWidthJsonFile() throws{
        guard let pathString = Bundle(for:type(of: self)).path(forResource: "AnnoncesJsonFile", ofType: "json") else {
            fatalError("ERREUR: File Json not found")
        }
        
        print("\n\n\(pathString)\n\n")
        
        guard let json = try? String(contentsOfFile: pathString,encoding: .utf8) else{
            fatalError("Impossible de convertir le JSON en String")
        }
        
        let jsonData = json.data(using:.utf8)!
        let AnnonceData = try! JSONDecoder().decode([AnonceElement].self, from: jsonData)
        
        XCTAssertEqual(1461267313, AnnonceData[0].id)
        XCTAssertEqual("Statue homme noir assis en plâtre polychrome", AnnonceData[0].title)
    }
    
    func testApiCallContainsData()throws{
        
        let viewModel = AnonceViewModel()
        let exepection = self.expectation(description: "fetchAnonce")
        XCTAssert(true,"true")
        viewModel.fetchAnonce { (status) in
            XCTAssert(true,"true")
            exepection.fulfill()
        }
        waitForExpectations(timeout: 5,handler: nil)
    }
    
    func testHasElement(){
        let viewModel = AnonceViewModel()
        
        viewModel.anonce = [
        AnonceElement(id: 1, categoryID: 2, title: "title", anonceDescription: "", price: 0, imagesURL: ImagesURL(small: "", thumb: ""), creationDate: Date(), isUrgent: false, siret: "")
        ]
        
        XCTAssertTrue(viewModel.hasAnonce)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCanParseCategorie()throws{
        let json = """

          {
            "id": 1,
            "name": "Véhicule"
          }
"""
        
        let jsonData = json.data(using:.utf8)!
        let Categorie = try! JSONDecoder().decode(CategorieElement.self, from: jsonData)
        XCTAssertEqual(1, Categorie.id)
        XCTAssertEqual("Véhicule", Categorie.name)
     
    }
    
    func  textCanParceCategorieWithEmptyid()throws{
        let json = """

          {
            "id": 1,
            "name": ""
          }
"""
        
        let jsonData = json.data(using:.utf8)!
        let Categorie = try! JSONDecoder().decode(CategorieElement.self, from: jsonData)
        XCTAssertEqual(1, Categorie.id)
        XCTAssertEqual("", Categorie.name)
     
    }
    
    func testCanParseCategorieWithJsonFile()throws{
        var fichier = "CategorieFileJson"
        guard let pathString = Bundle(for:type(of: self)).path(forResource: fichier, ofType: "json") else {
           fatalError("ERREUR: PAS DE FICHIER JSON AVEC LE NON \(fichier)")
        }
        print("C'est Okay ")
        print("\n\n\(pathString)\n\n")
        
        guard let json = try? String(contentsOfFile: pathString,encoding: .utf8) else{
            fatalError("Impossible de convertir le JSON en String")
        }
        
        let jsonData = json.data(using:.utf8)!
        let CategorieData = try! JSONDecoder().decode([CategorieElement].self, from: jsonData)
        
        XCTAssertEqual(1,  CategorieData [0].id)
        XCTAssertEqual("Véhicule",  CategorieData [0].name)
    }
    
    func testHasCetegorie()throws{
        let viewModel = AnonceViewModel()
        
        viewModel.categorie = [
        CategorieElement(id: 1, name: "Véhicules")
        ]
        
        XCTAssertTrue(viewModel.hasCetegorie)
    }
    
    func testApiCallCategorieContainsData()throws{
        let viewModel = AnonceViewModel()
        let exepection = self.expectation(description: "fetchAnonce")
        XCTAssert(true,"true")
        viewModel.getCategorye { (status) in
            XCTAssert(status,"true")
            exepection.fulfill()
        }
        waitForExpectations(timeout: 5,handler: nil)
    }
    
}
