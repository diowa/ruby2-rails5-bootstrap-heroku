process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const StyleLintPlugin = require('stylelint-webpack-plugin')

environment.plugins.append(
  'StyleLintPlugin',
  new StyleLintPlugin({
    files: '/app/**/*.(s(c|a)ss|css)'
  })
)

environment.loaders.get('babel').use.push({
  loader: 'standard-loader', options: { error: true }
})

module.exports = environment.toWebpackConfig()
