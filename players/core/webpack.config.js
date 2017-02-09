var webpack = require('webpack');
var path = require('path');

var BUILD_DIR = path.resolve(__dirname, 'dist');
var APP_DIR = path.resolve(__dirname, 'src');
var RESOURCES_DIR = path.resolve(__dirname, 'resources');

var HtmlWebpackPlugin = require('html-webpack-plugin');
var HtmlWebpackPluginConfig = new HtmlWebpackPlugin({
		template: path.resolve(__dirname, 'src/index.html'),
		filename: 'index.html',
		inject: 'body'
});

var ExtractTextPlugin = require("extract-text-webpack-plugin");
var StyleTextPluginConfig = new ExtractTextPlugin('style.css', { allChunks: true });
var MinifyPlugin = new webpack.optimize.UglifyJsPlugin({
	compress:{
		warnings: true
	}
});

var config = {
	entry: APP_DIR + '/index.jsx',
	resolve: {
		extensions: [ '', '.html', '.js', '.jsx', '.less' ]
	},
	output: {
		path: BUILD_DIR,
		filename: 'index.js'
	},
	module : {
		loaders : [
			{
				test : /\.jsx?/,
				include : APP_DIR,
				loader : 'babel',
				query : {
					presets : [ 'es2015', 'react', 'stage-1' ],
					plugins: [
						'transform-decorators-legacy',
					],
				},
			},
			{
				test: /\.less$/,
				include : APP_DIR,
				loader: ExtractTextPlugin.extract("style?sourceMap", "css?sourceMap!autoprefixer?browsers=last 2 version!less")
			},
			{
				test: /\.(jpe?g|png|gif|svg)$/i,
				incude: RESOURCES_DIR,
				loaders: [
					'file?hash=sha512&digest=hex&name=[hash].[ext]',
					'image-webpack?bypassOnDebug&optimizationLevel=7&interlaced=false'
				]
			}
		]
	},
	plugins: [
		HtmlWebpackPluginConfig,
		StyleTextPluginConfig,
		MinifyPlugin,
	]
};

module.exports = config;
