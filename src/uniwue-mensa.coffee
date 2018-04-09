BASE_URL="https://service.nosebrain.de/service/uni-wue/"

EMOJI_LOOKUP={
  "Alkohol": "🍸",
  "Fisch": "🐟",
  "Fleischlos": "🌽",
  "Geflügel": "🐔",
  "Kalb": "🐄",
  "Lamm": "🐏",
  "Rind": "🐄",
  "Schwein": "🐖",
  "Vegan": "🌱",
  "Vorderschinken": "🍖",
  "Wild": "🦌",
  "Burger": "🍔"
}

WEEKDAYS = [ "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag" ]

LOCATIONS = [
  #{name: "Frankenstube", id: 1},
  #{name: "Mensa", id: 2},
  {name: "Mensateria", id: 6},
  {name: "Outer-Rim-Mensa", id: 7}
]

build_plan_from_json = (json, weekday) ->
  data = JSON.parse json
  if(data.message)
    return data.message
  if (!data.days?)
    console.log("Error reading data")
    console.log(data)
    return "Error reading json from server. Please try again later"
  day = data.days[weekday]
  if day.holiday
    return "(geschlossen)"
  else
    foods = ("#{to_emojis(f)} #{f.description}: #{f.prices[0]} / #{f.prices[1]} / #{f.prices[2]}" for f in day.food)

    if (day.food.some (f) -> /burger/i.test(f.description))
      foods = ["🍔🍔🍔🍔🍔🍔 *BURGERALARM*  🍔🍔🍔🍔🍔🍔\n"].concat foods

    if (day.food.some (f) -> /currywurst/i.test(f.description))
      foods = ["🔔🔔🔔🔔🔔🔔 *CURRYWURST* 🔔🔔🔔🔔🔔🔔\n"].concat foods

    return foods.join("\n")


to_emojis = (food) ->
  #food.ingredients.push "Burger" if /burger/i.test(food.description)
  (EMOJI_LOOKUP[i] for i in food.ingredients).join " "
    
day_name = (weekday, offset) ->
  if offset == 0
    return "heute"
  else if offset == 1
    return "morgen"
  else if offset == -1
    return "gestern"
  else if offset < 0
    return "letzten " + WEEKDAYS[weekday]
  else
    return WEEKDAYS[weekday]

retrievePlan = (robot, location, weekday) ->
  new Promise (resolve) ->
    robot.http(BASE_URL + location.id + "/CURRENT.json")
      .header('Accept', 'application/json')
      .get() (err, res, body) => resolve("*#{location.name}*:\n#{build_plan_from_json(body, weekday)}")

mensaplan = (robot, response) ->
  offset = response.match[1] * 1
  offset = 0 if isNaN(offset)
  weekday = new Date().getDay() - 1 + offset
  if weekday < 0 || weekday > 4
    response.send("Ungültiger Offset! Nur aktuelle Woche Montag - Freitag.")
    return

  day = day_name(weekday, offset)

  Promise.all(LOCATIONS.map (loc) -> retrievePlan(robot, loc, weekday))
    .then (plans) -> response.send "Speiseplan für #{day}:\n#{plans.join("\n")}"

# here we call the hubot api to react to messages
module.exports = (robot) ->
  # someone mentioning the bot and saying !mensa
  robot.respond /!mensa/i, (response) ->
    mensaplan(robot, response)
  # any message starting with !mensa, optional offset
  robot.hear /^!mensa ?(\S*)/i, (response) ->
    mensaplan(robot, response)
