angular.module "moviedbdemo.controllers", []

  .controller 'MainController', ($scope, $http, $timeout, OpenMovieDB, $location) ->
    $scope.init = () ->
      $scope.main_search_value = ''

    $scope.setCurrentView = (current) ->
      $scope.currentView =
        recent: false
        top100: false
        addreview: false
        tutorials: false
      if current
        $scope.currentView[current] = true

    $scope.navigate_to_movie = (id, imdbid) ->
      if not id or not imdbid
        console.error "cannot navigate without ID and imdbid!"
        return
      $location.url "/details/#{id}/#{imdbid}"

    $scope.update_omdb_search = (value, timeout, cb, type='') ->
      search_omdb = ->
        OpenMovieDB.get
          title: value
          type: type
        , (response) ->
          if response.Response
            $timeout.cancel timeout
            cb response

      if timeout
        $timeout.cancel timeout
      return $timeout search_omdb, 500

    $scope.search_movietitle = (value) ->
      return $http.get '/api/review',
        params:
          movietitle: value
      .then (response) ->
        console.log response.data.reviews
        return response.data.reviews

    $scope.init()


  .controller 'RecentController', ($scope, ReviewApi, OpenMovieDB) ->
    $scope.init = ->
      $scope.setCurrentView 'recent'
      $scope.movies = []
      $scope.posters = {}
      ReviewApi.get (response) ->
        if not response.status
          console.error response.error
          return
        $scope.reviews = response.reviews

    $scope.test_something = (text="some test here") ->
      console.log text

    $scope.get_poster_url = (imdbid) ->
      OpenMovieDB.get
          imdbid: imdbid
        , (response) ->
          if response.Response
            $scope.posters[imdbid] = response.Poster

    $scope.init()


  .controller 'DetailsController', ($scope, $routeParams, $location, OpenMovieDB, ReviewApi) ->
    $scope.init = ->
      $scope.setCurrentView ''
      $scope.review =
        movietitle: ''
        imdbid: ''

      $scope.omdbmovie = {}
      $scope.omdbkeys = [
        'Year'
        'Rated'
        'Released'
        'Runtime'
        'Genre'
        'Director'
        'Writer'
        'Actors'
        'Plot'
        'Awards'
        'Language'
        'Country'
        'imdbRating'
        'Type'
        'tomatoRating'
      ]

      ReviewApi.get
          id: $routeParams.id
          imdbid: $routeParams.imdbid
        , (response) ->
          if not response.status
            console.error response.error
            return
          $scope.review = response.review
          $scope.others = response.others
          $scope.load_from_omdb()

    $scope.load_from_omdb = ->
      OpenMovieDB.get
          imdbid: $scope.review.imdbid
        , (response) ->
          if response.Response
            $scope.omdbmovie = response

    $scope.delete_review = ->
      console.log "deleting #{$scope.review._id}"
      ReviewApi.delete
        id: $scope.review._id
      , (response) ->
        if not response.status
          console.error response.error
          return
        $location.url '/recent'

    $scope.init()


  .controller 'AddReviewController', ($scope, $location, ReviewApi) ->
    $scope.init = ->
      $scope.setCurrentView 'addreview'
      $scope.omdb =
        status: 'init'
        movie: null
      $scope.review =
        username: ''
        imdbid: ''
        header: ''
        text: ''
        movietitle: ''
        rating: 5
        created: ''
      $scope.omdbsearch = ''

      $scope.movieselection =
        isopen: false
        selected_index: 0
        types: [
            'movie'
            'series'
            'episode'
          ]

    $scope.omdb_search_callback = (response) ->
      $scope.omdb.movie = response
      $scope.omdb.status = 'recieved'

    $scope.select_omdb_movie = ->
      $scope.omdb.status = 'selected'
      $scope.review.movietitle = $scope.omdb.movie.Title
      $scope.review.imdbid = $scope.omdb.movie.imdbID

    $scope.range = (n) ->
      return new Array n

    $scope.save_review = ->
      $scope.review.created = new Date
      $scope.reviewerror = false
      for k, v of $scope.review
        if v is ''
          $scope.reviewerror = true
          $scope.reviewerrortext = "All fields must be filled in.. (#{k} is blank)"
          return

      ReviewApi.save $scope.review, (response) ->
        if response.status
          $location.url '/recent'
        else
          $scope.reviewerror = true
          $scope.reviewerrortext = "Server returned error: #{response.error}"

    $scope.on_rating_hover = (value) ->
      console.log 'on_rating_hover'
      $scope.hover_on_star = value
      $scope.percent = 100 * (value / 10)

    $scope.init()

  .controller 'TutorialsController', ($scope) ->
    $scope.setCurrentView 'tutorials'
    console.log 'TutorialsController running!'