@0xe2bee94e57864655;

#### Common structs

struct Pos {
    x @0 :Int32;
    y @1 :Int32;
}

struct Size {
    w @0 :Int32;
    h @1 :Int32;
}


#### Client messages

struct ClientState {
    layer @0 :Int32;
    cursorPos @1 :Pos;
}

struct KeyPress {
    modifier @0 :Int8;
    key @1 :Text;
}


#### Server messages

struct GridUpdate {
    layer @0 :Int32;
    gridPos @1 :Pos;
    tile @2 :Pos;
}

struct ClientScript {
    script @0 :Text;
}
