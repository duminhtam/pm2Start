create a startup.coffee file

```
pm2Start = require './lib/pm2/pm2Start'
argv = require('yargs').argv;
config = require 'config'

apps = config.get 'pm2Start.apps'

pm2Start.app apps
.then (startedApps) ->
  for startedApp in startedApps
    console.log 'started:',startedApp
.catch (err) ->
  console.log 'err',err

process.on 'errException', (exception) ->
  console.log 'exception:', exception

```

sample config:

```
pm2Start:
  apps:
    backend.coffee:
#    Backend can not cluster by PM2 we use Nginx -> so duplicate by config
      -
        nodename: pusher
        instances: 1
        max_memory_restart : '100M'
        exec_mode : 'cluster'
        env:
          PORT: 13000
      -
        nodename: pusher
        instances: 1
        max_memory_restart : '100M'
        exec_mode : 'cluster'
        env:
          PORT: 13001

    heartbeats.coffee:
      nodename: pusher
      instances: 1
      max_memory_restart : 100M
      exec_mode : cluster
      env:
        PORT: 0

```
coffee config

```
module.exports =
  pm2Start:
    apps:
      'myapp.coffee': [
        {
        'nodename': 'myHackingApp'
        'max_memory_restart': '100M'
        'instances': 1
        'exec_mode': 'cluster'
        }
      ]
      
```
