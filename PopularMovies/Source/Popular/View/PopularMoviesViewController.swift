//
//  PopularMoviesViewController.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

import UIKit

class PopularMoviesViewController: UIViewController {
    
    private var popularMoviesView = PopularMoviesView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func loadView() {
        self.view = popularMoviesView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
