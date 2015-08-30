# Installation

There are two ways to install Horror Story.

## 1. Steam Workshop (easiest)

You can subscribe to Horror Story on the Steam Workshop. It will supply you with
all the updates you could think of. Here's a step by step guide:

### Steam Workshop for clients
1. [Go to Horror Story on the Steam Workshop][steam]
2. Click `Subscribe`.
3. Launch Garry's Mod
4. The addon is downloaded automatically.
5. Select "Horror Story" from the Gamemodes menu (bottom right of the main menu)
6. Have fun

### Steam Workshop for servers
1. [Go to Horror Story on the Steam Workshop][steam]
2. Add the addon to a collection of your own
3. Figure out what the collection ID is.
4. Start the server, supplying the collection ID and your Steam API key as command line arguments.
   This looks something like: `+host_workshop_collection WORKSHOPID -authkey YOURKEYGOESHERE`
5. Wait for the Source Dedicated Server to download Horror Story
6. Launch a horror map using `gamemode horrorstory` and `map <mapname>`
7. Have fun

For more information on how to do the server stuff, [read the Garry's Mod Wiki][wiki].


## 2. Clone the raw code using git.

1. Go to your `/addons` directory in a terminal or command line interface (bash/sh on Linux, cmd on Windows)
2. `git clone` this repository into it's own directory
3. Launch Garry's Mod or your Source Dedicated Server
4. Have fun
5. Update regularly (using `git pull`)

Make sure you update your git copy regularly, to not miss out on any bleeding edge
updates. You may also choose to checkout the *stable* branch for less frequent
updates (which is essentially the same as using the Workshop, but without the
Workshop)

    [steam]: http://steamcommunity.com/sharedfiles/filedetails/?id=124828021
    [wiki]: http://wiki.garrysmod.com/page/Workshop_for_Dedicated_Servers
