Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/uniwue-mensa.coffee')

describe 'uniwue-mensa', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'hears !mensa at start of line', ->
    @room.user.say('alice', '!mensa').then =>
      expect(@room.messages).to.have.length.of.at.least(2)

  it 'responds to !mensa', ->
    @room.user.say('alice', 'hubot !mensa').then =>
      expect(@room.messages).to.have.length.of.at.least(2)

