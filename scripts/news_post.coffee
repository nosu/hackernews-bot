cronJob = require('cron').CronJob
request = require('request')

module.exports = (robot) ->
  room = room: "articles"
  new cronJob '0 55 8-23/3 * * *', () ->
    postRecentArticles robot, score, room
  , null
  , true
  , 'Asia/Tokyo'

  robot.respond /(please|plz) (.*)/i, (res) ->
    score = 1000
    if res.match[2]
      score = res.match[2]
    replyRecentArticles(res, score)

  getArticles = (score, callback) ->
    request "http://hnapp.com/json?q=score%3E#{score}", (error, response, body) ->
      if !error && response.statusCode == 200
        resultJson = JSON.parse(body)
        callback resultJson.items

  postRecentArticles = (robot, score, room) ->
    articles = getArticles score, (articles) ->
      for article, index in articles
        robot.send room "#{article.title}(Score: #{article.score})\n#{article.url}"

  replyRecentArticles = (res, score) ->
    articles = getArticles score, (articles) ->
      for article, index in articles
        res.send "#{article.title}(Score: #{article.score})\n#{article.url}"

  robot.respond /test/i, (res) ->
    res.send "test ok"
