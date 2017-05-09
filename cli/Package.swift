import PackageDescription

let package = Package(
	name: "Amethyst-CLI",
	dependencies: [
		.Package(url: "https://github.com/randymarsh77/async", majorVersion: 1),
		.Package(url: "https://github.com/randymarsh77/asyncprocess", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/awaitables", majorVersion: 0),
		.Package(url: "https://github.com/randymarsh77/time", majorVersion: 2),
	]
)
