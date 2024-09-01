@0xe2bee94e57864655;
# Olarnp
#
# A Cap'n Proto specification for implementing 2D, tile-based, client-server
# protocols, such as for single- or multi-player roguelike games.
#
# Copyright (C) 2024 Isaac Freeman <memotype@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#### Common structs

struct Pos {
    # General position struct (signed to represent relative positions)
    x @0 :Int32;
    y @1 :Int32;
}

struct Size {
    # General size struct
    w @0 :UInt32;
    h @1 :UInt32;
}

struct Color {
    # Red, green, blue, alpha
    r @0 :UInt8;
    g @1 :UInt8;
    b @2 :UInt8;
    a @3 :UInt8;
}

struct Error {
    # General error struct used by many client/server response messages.
    union {
        fail @0 :Text;
        # A generic error. If you find yourself using this, consider adding
        # another, more specific error condition to this union

        fileError @1 :Text;
        imageError @2 :Text;
    }
}

struct Response(ResponseType, ErrorType) {
    # Generalized response message
    # See ResponseType above
    union {
        ok @0 :ResponseType;
        error @1 :Error;
    }
}

struct TilesetId {
    # This is a struct so it can be used in generic types
    id @0 :UInt16;
}

struct LayerId {
    # Just like TilesetId
    id @0 :UInt16;
}

struct ScriptId {
    # Just like TilesetId
    id @0 :UInt16;
}


#### Client messages

# General client messages
struct ClientState {
    # A message to communicate the current client state
    # TODO: expand as client is developed
    layer @0 :Int32;
    cursorPos @1 :Pos;
}

# User input messages
struct KeyMods {
    # Describes which modifier keys were held when the key was pressed
    # (shift, ctrl, alt, meta)
    shift @0 :Bool;
    ctrl  @1 :Bool;
    alt   @2 :Bool;
    meta  @3 :Bool;
}

struct KeyDown {
    # Client keyboard press
    key @0 :UInt16;
    mods @1 :KeyMods;
}

struct KeyUp {
    # Client keyboard release
    key @0 :UInt16;
    mods @1 :KeyMods;
}

struct MouseClick {
    # Client-side mouse-click. Message contains relative mouse cursor position
    # and a KeyMods struct representing the modifier keys that were held
    pos @0 :Pos;
    mods @1 :KeyMods;
}

# Client responses

struct LoadTilesetResponse {
    # Response to a LoadTileset message, returning either a TilesetId, which
    # can be used in other messages to refer to this tileset, or an Error
    tilesetId @0 :Response(TilesetId, Error);
}

struct CreateLayerResponse {
    # Response to a CreateLayer message, returning either a LayerId, which
    # can be used in other messages to refer to this layer, or an Error
    layerId @0 :Response(LayerId, Error);
}

struct ClientScriptResponse {
    # Response to a LoadClientScript message, returning either a ScriptId,
    # which can be used in other messages to refer to this layer, or an Error
    scriptId @0 :Response(ScriptId, Error);
}


#### Server messages

struct TilesetPackage {
    # Send a compressed tileset package to the client. This must have a unique
    # name, include the compression algorithm, the file data, and at least one
    # supported checksum.
    packageName @0 :Text;
    # Name of the image package
    packageFormat @1 :Text;
    # The format of the package (zip, gz, etc)
    packageData @2 :Data;
    # The package file being uploaded to the client
    packageChecksum :union {
        md5 @3 :Text;
        sha1 @4 :Text;
        sha256 @5 :Text;
    }
    # Currently support checksum algorithms are: MD5, SHA-1, and SHA-256
}

struct LoadTileset {
    # Load a tileset package
    union {
        localPackage @0 :Text;
        # Load a package that's local to the client
        remotePackage @1 :TilesetPackage;
        # Load the package being sent as a TilesetPackage message
    }
}

struct StaticTile {
    # A tile position within a static tileset
    tileset @0 :TilesetId;
    tile @1 :Pos;
}

struct DynamicTile {
    # A tile whose sprite is a single image that can be animated and/or oversized
    tile @0 :TilesetId;
}

struct CreateLayer {
    # Tell the client to create a new rendering layer. By default, this will
    # become the top layer, but a LayerId cen be provided to the 'insert' union
    # and it will be inserted into the layer stack before this LayerId. The
    # client will respond with a new, unique LayerId. Existing LayerId's will
    # be unaffected.
    tileset @0 :TilesetId;
    insert :union {
        top @1 :Void;
        layerNum @2 :LayerId;
    }
}

struct LayerUpdate {
    # Update the contents of a layer's tile grid
    layer @0 :LayerId;
    # The layer to update
    layerPos @1 :Pos;
    # The position in the layer's tile grid to update
    union {
        staticTile @2 :StaticTile;
        dynamicTile @3 :DynamicTile;
    }
}

struct ClientScript {
    # Describes a client-side script. These are useful to reduce client-server
    # back-and-forth
    script @0 :Text;
    enum Language {
        # Currently supported scripting languages
        guile @0;
        # GNU Guile scheme
    }
}

struct LoadClientScript {
    # Client-side script. See the scripting documentation for more. Will return
    # a ScriptId to refer to the script in other messages.
    union {
        localScript @0 :Text;
        # Load a client script that's local to the client
        remoteScript @1 :ClientScript;
        # Load the script being sent as a TilesetPackage message
    }
    init @2 :Text;
    # An S-expr of initialization values for the script
}

struct ScriptCall {
    # Call a function from a ClientScript and return it's output
    scriptId @0 :ScriptId;
    # ScriptId returned from the LoadClientScript message
    args @1 :Text;
    # S-expr representing arguments
}
