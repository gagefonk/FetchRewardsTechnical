//
//  MainViewVM.swift
//  FetchRewardsTechnical
//
//  Created by Gage Fonk on 9/10/21.
//

import Foundation

class MainViewVM {
    
    //decalre api variables
    let categoryBaseURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    let mealBaseURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    let mealDetailsBaseURL = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
    let dispatchGroup = DispatchGroup()
    
    //data
    var displayData = [DisplayData]()
    
    //fetch data
    func fetchData(completion: @escaping () -> Void) {
        formatCategories {
            self.formatMeals {
                completion()
            }
        }
    }
    
    func formatCategories(completion: @escaping (()->Void)) {
        dispatchGroup.enter()
        getCategories { categoryData in
            var sortedData = categoryData.sorted { $0.strCategory < $1.strCategory }
            sortedData.removeAll(where: { $0.strCategory == "" })
            sortedData.forEach { data in
                let dd = DisplayData(category: data.strCategory)
                self.displayData.append(dd)
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func formatMeals(completion: @escaping (()->Void)) {
        
        for i in 0..<displayData.count {
            dispatchGroup.enter()
            getMeals(category: displayData[i].category) { mealData in
                var sortedData = mealData.sorted { $0.strMeal < $1.strMeal}
                sortedData.removeAll(where: { $0.strMeal == "" })
                self.displayData[i].meals = sortedData
                self.dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func getCategories(completion: @escaping ([MealCategory])->()) {
        
        dispatchGroup.enter()
        guard let url = URL(string: categoryBaseURL) else { return }
        
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data else {
                print(error!)
                self.dispatchGroup.leave()
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Root.self, from: data)
                completion(result.categories)
                self.dispatchGroup.leave()
            }
            catch let parsingError {
                print(parsingError)
                self.dispatchGroup.leave()
            }
            
        }.resume()
    }
    
    func getMeals(category: String, completion: @escaping ([Meals])->()) {
        
        guard let url = URL(string: mealBaseURL + category) else { return }
        
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data else {
                print(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Category.self, from: data)
                completion(result.meals)
            }
            catch let parsingError {
                print(parsingError)
            }
        }.resume()
    }
    
    func getMealDetails(mealID: String, completion: @escaping (MealDetails) -> Void) {
        
        guard let url = URL(string: mealDetailsBaseURL + mealID) else { return }
        
        URLSession.shared.dataTask(with: url) { data, urlResponse, error in
            guard let data = data else {
                print(error!)
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(MealDetailsHolder.self, from: data)
                completion(result.meals[0])
            }
            catch let parsingError {
                print(parsingError)
            }
        }.resume()
    }
    
    
    
}
