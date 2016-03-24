cronJob = require('cron').CronJob
request = require('request')

module.exports = (robot) ->
  room = {room: "#articles"}
  new cronJob '0 55 8-23/3 * * *', () ->
    postRecentArticles(robot)
  , null
  , true
  , 'Asia/Tokyo'

  robot.respond /please/i, (res) ->
    postRecentArticles(res)

  getArticles = (callback, res) ->
    request 'http://hnapp.com/json?q=score%3E1000', (error, response, body) ->
      if !error && response.statusCode == 200
        resultJson = JSON.parse(body)
        callback resultJson.items

  postRecentArticles = (res) ->
    articles = getArticles (articles) ->
      res.send "postRecentArticles"
      for article, index in articles
        res.send article.url
    , res

  robot.respond /test/i, (res) ->
    res.send "test ok"
