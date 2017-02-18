import PackageDescription

let package = Package(
    name: "Dependencies",
    dependencies: [
		.Package(url: "https://github.com/randymarsh77/async", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/bonjour", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/crystal", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/fetch", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/itunes", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/inmemorycache", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/spectrum", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/time", majorVersion: 2),
		.Package(url: "https://github.com/randymarsh77/using", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/wkinterop", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/wkinterop-gloss", majorVersion: 0),
		.Package(url: "https://github.com/hkellaway/gloss", majorVersion: 1),
		.Package(url: "https://github.com/vapor/redbird", majorVersion: 0),
		.Package(url: "https://github.com/vapor/vapor", majorVersion: 1, minor: 5),
	]
)
