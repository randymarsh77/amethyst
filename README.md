# Amethyst
A home audio solution. Kind of.

## Overview
Amethyst is a bundled deployment for wireless, synchronized audio playback to multiple clients.
The project is built on top of [Crystal](https://github.com/randymarsh77/crystal), and is a collection of content, metadata, and control servers orchestrated by a CLI and consumed by player client applications. Amethyst is targeted at single home deployments serving a few clients with single instances of each server. IE, it is not set up for multi-node deployments, load balancing, authenticated content, etc.

## Usage
- Run the CLI on a Mac to serve audio.
- Run the client applications to play the audio.

## Caveats
- The CLI is not built, so you actually need to launch each server manually ATM.
- The only player implemented is iOS, and it's swift 3 requiring iOS 10+ :(

## Future
- Build a CLI
- Build Linux and web clients (Likely the Linux clients will be headless CLI, and a web client for GUI)
- Port iOS builds back to iOS 9, somehow. :/
