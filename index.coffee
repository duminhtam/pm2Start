pm2 = require 'pm2'
require 'shelljs/global'

# Config
#process.env.NODE_ENV = 'staging'
env = process.env.NODE_ENV || 'default'

class pm2Start
  @createConfig : (apps) ->
    configs = []
    for pfilename, app_configs of apps
      unless Array.isArray app_configs
        app_configs = [app_configs]

      for config in app_configs
        port = 0
        if typeof config.env != 'undefined'
          if typeof config.env.PORT != 'undefined'
            port = config.env.PORT

        [filepath...,filename] = pfilename.split '/'
        [app,ext...] = filename.split '.'

        config.name = "#{config.nodename}-#{app}-#{port}-#{env}"
        config.instances = config.instances || 1
        config.script   = "./#{pfilename}"

        configs.push config
    return configs
  @app: (apps) ->
    configs = @createConfig apps
    ## Create log folder
    return new Promise (resolve, reject) ->
      pm2.connect (err,a) ->
        if err
          console.log 'err',err

        pm2.start configs, (err, proc) ->
          if err
            reject err
          # Get all processes running
          pm2.list (err, process_list) ->
            resolve startedApps = process_list.map (k,v) ->
              return k.name

            # Disconnect to PM2
            pm2.disconnect ->
              process.exit 0
              return
            return
          return
        return
      return

module.exports = pm2Start
