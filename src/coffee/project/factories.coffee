angular.module "moviedbdemo.factories", ['ngResource']

  .factory 'OpenMovieDB', ($resource) ->
    $resource 'http://www.omdbapi.com/?type=:type&i=:imdbid&t=:title&y=:year&tomatoes=true&plot=full&r=json',
      title: '@title'
      year: '@year'
      imdbid: '@imdbid'
      type: '@type'

  .factory 'ReviewApi', ($resource) ->
    $resource '/api/review?id=:id&imdbid=:imdbid&movietitle=:movietitle',
      id: '@id'
      imdbid: '@imdbid'
      movietitle: '@movietitle'


