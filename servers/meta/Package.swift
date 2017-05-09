import PackageDescription

let package = Package(
    name: "Amethyst-MetaServer",
    dependencies: [
		.Package(url: "https://github.com/randymarsh77/bonjour", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/itunes", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/inmemorycache", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/using", majorVersion: 1),
		.Package(url: "https://github.com/vapor/redbird", majorVersion: 0),
		.Package(url: "https://github.com/vapor/vapor", majorVersion: 1, minor: 5),
	]
)
