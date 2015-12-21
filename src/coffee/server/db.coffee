####################
# DB setup
####################
connection_url = 'mongodb://localhost:27017/moviedemodb'

if process.env.DOMREPLAY_DB_CONNECTION
  connection_url = process.env.DOMREPLAY_DB_CONNECTION
else if process.env.MONGOLAB_URI
  connection_url = process.env.MONGOLAB_URI

console.log "#####"
console.log "  Connecting to: #{connection_url}"
console.log "#####"

connection = mongoose.connect connection_url

reviewSchema = new Schema
  username: String
  imdbid: String
  header: String
  text: String
  movietitle: String
  rating: Number
  created: Date

Review = mongoose.model 'reviewmodel', reviewSchema, 'reviewmodel'


tutorialSegment = new Schema
  user_id: Number
  data: [
    {
      event_type: String
      id: String
      value: String
    }
  ]

 TutorialSegment = mongoose.model 'tutorialsegmentmodel', tutorialSegment, 'tutorialsegmentmodel'


server = app.listen PORT, URL, () ->
  console.log "server running on port #{PORT}"
  return
