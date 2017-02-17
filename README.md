# hubot-uniwue-mensa

Lets Hubot get the mensa food plan for Uni Würzburg

## Dependencies

This depends on JSON requested from a unofficial server not affiliated with 
Studentenwerk Würzburg and will stop working when that server is down.

The source for the json server can be found at https://bitbucket.org/nosebrain/cafeteria-menu-service

## Installation

In hubot project repo, run:

`npm install hubot-uniwue-mensa --save`

Then add **hubot-uniwue-mensa** to your `external-scripts.json`:

```json
[
  "hubot-uniwue-mensa"
]
```

## Sample Interaction

```
user1>> !mensa
hubot>> Speiseplan für heute:...
```

## NPM Module

https://www.npmjs.com/package/hubot-uniwue-mensa
