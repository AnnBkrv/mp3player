//
//  searchBarClasses.swift
//  mp3_player
//
//  Created by Anna Bukreeva on 07.03.21.
//

import SwiftUI



final class ViewControllerResolver: UIViewControllerRepresentable {
//    UIViewControllerRepresentable is a way to create and manage UIViewController instances in SwiftUI interfaces.
    
//    View controllers hold a reference to their parent view controllers in a parent property. In addition, they expose a pretty useful template method called didMove(toParent:). We can use that method to get a reference to the actual hosting view controller of our SwiftUI list.
    
    let onResolve: (UIViewController) -> Void
    
    init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
        }
    
    func makeUIViewController(context: Context) -> ParentResolverViewController {
        
        ParentResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
        
    init(onResolve: @escaping (UIViewController) -> Void) {
            self.onResolve = onResolve
            super.init(nibName: nil, bundle: nil)
        }
//    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            print("didMove(toParent: \(parent)")
            onResolve(parent)
        }
    }
}


class SearchControllerProvider {
    
    let searchController: UISearchController
    
    init() {
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.obscuresBackgroundDuringPresentation = false
    }
}


//search bars using UIKit in SwiftUI: http://blog.eppz.eu/swiftui-search-bar-in-the-navigation-bar/
// we are trying to add the seach bar using a single line of code. that can be accomplished if we directly apply the search bar modifier
// to the view controller. so the challenge is figuring out how to access the view controller of the LIST, to which we want to add a search bar.





class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}

extension SearchBar: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
        }
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
