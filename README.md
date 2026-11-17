# Azeroth After Dark

The latest **World of Warcraft: Forever** news, hotfixes and screenshots, right in game, from the team behind
[Azeroth After Dark](https://wow.afterdark.fm).

- Opens by itself when you log in and there's a story you haven't seen yet.
- Front page: the top story with its picture, plus every other headline with a thumbnail.
- Click a story to read it: pictures you can flip through, the full brief, a "What changed" list for hotfixes,
  and the original article's link to copy.
- Minimap button with an unread count.

## Commands

| Command | What it does |
| --- | --- |
| `/aad` (or `/afterdark`, `/wownews`) | Open or close the news |
| `/aad popup new\|always\|off` | Open on login: when there's a new story (default), every login, or never |
| `/aad minimap` | Show or hide the minimap button |
| `/aad reset` | Put the window back in the middle of the screen |

## How the news gets here

WoW addons can't go online, so each edition ships inside the addon: `News.lua` holds the stories and
`Media/news/` their pictures. A new edition is published every day; update the addon to get it.
If your copy is more than four days old, the window tells you.

The stories are short briefs written for Azeroth After Dark from the reporting of Wowhead, Blizzard and Icy Veins,
always linked at the bottom of each story. Pictures are credited to their source.

## Install

Download the latest zip from [Releases](https://github.com/QapHub/AzerothAfterDark/releases/latest) (a new one every day), or point
an addon manager that installs from GitHub (e.g. WowUp) at this repo. Unzip the `AzerothAfterDark` folder into `World of Warcraft\_forever_\Interface\AddOns\` and restart the game
(a `/reload` isn't enough for new pictures: the game only finds new texture files when it starts).

## For developers

- `tests/`: headless tests under fengari, `node tests/run.js tests/test.lua`.
- `tools/make-media.js`: builds the fixed textures (logo, placeholder, dot).
- Editions are written by the newsroom tool in the show's app (`wow-podcast/tools/addon-news.mjs`).

MIT licensed.
