angular.module "moviedbdemo.routes", ['ngRoute']

  .config ['$routeProvider',
      ($routeProvider) ->
        $routeProvider
          .when '/recent',
            templateUrl: '/recent.html'
            controller: 'RecentController'
          .when '/details/:id/:imdbid',
            templateUrl: '/details.html'
            controller: 'DetailsController'
          .when '/addreview',
            templateUrl: '/addreview.html'
            controller: 'AddReviewController'
          .when '/tutorials',
            templateUrl: '/tutorials.html'
            controller: 'TutorialsController'
          .otherwise
            redirectTo: '/recent'

    ]