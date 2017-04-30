import PackageDescription

let package = Package(
    name: "content-server",
    dependencies: [
		.Package(url: "https://github.com/randymarsh77/asyncprocess", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/bonjour", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/crystal", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/using", majorVersion: 1),
	]
)
