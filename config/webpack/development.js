process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const StyleLintPlugin = require('stylelint-webpack-plugin')

environment.plugins.append(
  'StyleLintPlugin',
  new StyleLintPlugin({
  })
)

module.exports = environment.toWebpackConfig()
