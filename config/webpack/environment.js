const { environment } = require('@rails/webpacker')

const webpack = require('webpack')

// resolve-url-loader must be used before sass-loader
const sassLoader      = environment.loaders.get('sass')
const findSassLoader  = loader => (loader === 'sass-loader' || loader.loader === 'sass-loader')
const sassLoaderIndex = sassLoader.use.findIndex(findSassLoader)

sassLoader.use.splice(sassLoaderIndex, 0, {
  loader: 'resolve-url-loader',
  options: {
    attempts: 1
  }
})

// Get a pre-configured plugin
environment.plugins.get('ExtractText') // Is an ExtractTextPlugin instance

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    // jQuery
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery',

    // Window
    'window.Tether': 'tether',
    'window.jQuery': 'jquery',

    // Bootstrap dependencies
    Popper: ['popper.js', 'default'],

    // Rails dependencies
    ActionCable: 'actioncable',
    Turbolinks: 'turbolinks',
    RailsUjs: 'rails-ujs',

    // Individual Bootstrap plugins
    Util:"exports-loader?Util!bootstrap/js/dist/util",
    Tooltip:"exports-loader?Tooltip!bootstrap/js/dist/tooltip",
    Popover:"exports-loader?Popover!bootstrap/js/dist/popover",
    Alert:"exports-loader?Alert!bootstrap/js/dist/alert",
    Carousel:"exports-loader?Carousel!bootstrap/js/dist/carousel",
    Dropdown:"exports-loader?Dropdown!bootstrap/js/dist/dropdown",
    Modal:"exports-loader?Modal!bootstrap/js/dist/modal",
    Tab:"exports-loader?Tab!bootstrap/js/dist/tab",
    Scrollspy:"exports-loader?Scrollspy!bootstrap/js/dist/scrollspy",
    Collapse:"exports-loader?Collapse!bootstrap/js/dist/collapse",
    Button:"exports-loader?Button!bootstrap/js/dist/button"
  })
)

// export the updated config
module.exports = environment
