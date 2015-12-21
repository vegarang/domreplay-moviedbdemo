###
 Utilities
###

handleError = (res, errmsg) ->
  res.json
    status: false
    error: errmsg

returnTutorialSegment = (status, res, tutorialSegment) ->
  if not tutorialSegment
    return handleError "No tutorialSegment found - got null", res
  res.json
    status: status
    session_id: tutorialSegment._id
    user_id: tutorialSegment.user_id
    data: tutorialSegment.data

createTutorialSegment = (res, values) ->
  tutorialSegment = new TutorialSegment values
  tutorialSegment.save (err, tutorialSegment) ->
    if err
      return handleError(err, res)
    returnTutorialSegment "created", res, tutorialSegment

updateTutorialSegment = (res, values) ->
  query =
    _id: values._id
  update =
    data: values.data
    user_id: values.user_id

  TutorialSegment.findOneAndUpdate query, update, {new: true}, (err, tutorialSegment) ->
    if err
      return handleError err, res
    returnTutorialSegment "updated", res, tutorialSegment

###
  /api/review/

  Used for storing/retrieving reviews (as in - the normal operation of the website)
###

app.get '/api/review', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  valid = false

  if not req.query.movietitle and not req.query.id
    # returning last 50
    Review.find()
      .sort '-date'
      .limit 50
      .exec (err, reviews) ->
        if err
          return handleError res, err
        res.json
          status: true
          reviews: reviews
    return

  queries = 0
  returns = 0
  retval =
    status:true

  return_data = ->
    returns++
    if queries == returns
      res.json retval

  if req.query.id
    queries++
    idquery = Review.findOne
        _id: req.query.id
      .exec (err, review) ->
        if err
          return handleError res, err
        retval.review = review
    idquery.then return_data

  if req.query.imdbid
    queries++
    imdbquery = Review.find
        imdbid: req.query.imdbid
      .sort '-date'
      .select 'username rating header imdbid _id'
      .exec (err, reviews) ->
        if err
          return handleError res, err
        retval.others = reviews
    imdbquery.then return_data

  if req.query.movietitle
    queries++
    titlequery = Review.find
        movietitle:
          $regex: req.query.movietitle
          $options: 'i'
      .sort '-date'
      .exec (err, reviews) ->
        if err
          return handleError res, err
        retval.reviews = reviews
    titlequery.then return_data


app.post '/api/review/', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  if not req.body.username
    console.log 'missing username'
    return handleError res, 'missing username'

  if not req.body.imdbid
    console.log 'missing imdbid'
    return handleError res, 'missing imdbid'

  if not req.body.header
    console.log 'missing header'
    return handleError res, 'missing header'

  if not req.body.text
    console.log 'missing text'
    return handleError res, 'missing text'

  if not req.body.movietitle
    console.log 'missing movietitle'
    return handleError res, 'missing movietitle'

  if not req.body.rating
    console.log 'missing rating'
    return handleError res, 'missing rating'

  review = new Review req.body
  review.save()

  res.json
    status: true
    review: review


app.delete '/api/review/', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  if not req.query.id
    console.log "missing id"
    return handleError res, "missing id"

  Review.findOneAndRemove
    _id: req.query.id
  .exec (err, something) ->
    if err
      return handleError res, err
    res.json
      status: true

###
  /api/tutorial/

  Used for storing/retrieving DOMReplay TutorialSegments
###

app.get '/api/tutorial/', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  if not req.query.session_id
    res.json
      status: "error"
      msg: "cannot fetch tutorialSegment without session_id"

  tutorialSegment_values =
    _id: req.query.session_id

  if req.query.user_id
    tutorialSegment_values['user_id'] = req.query.user_id

  TutorialSegment.findOne tutorialSegment_values, (err, tutorialSegment) ->
    if err
      return handleError err, res

    returnTutorialSegment "success", res, tutorialSegment


app.post '/api/tutorial/', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  tutorialSegment_values =
    data: req.body.data

  if req.body.user_id
    tutorialSegment_values['user_id'] = req.body.user_id

  if not req.body.session_id
#creating new
    createTutorialSegment res, tutorialSegment_values
  else
#updating existing
    tutorialSegment_values['_id'] = req.body.session_id
    updateTutorialSegment res, tutorialSegment_values

app.post '/api/tutorial/all/', (req, res) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"

  query_obj = {}

  if req.query.user_id
    query_obj.user_id = req.query.user_id

  console.log "request user_id: #{req.query.user_id}, query_obj:"
  console.log query_obj

  TutorialSegment.find query_obj, '_id user_id', (err, docs) ->
    if err
      return handleError err, res

    for doc in docs
      doc.session_id = doc._id
      delete doc._id
    res.json
      status: "success"
      data: docs