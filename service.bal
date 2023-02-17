import ballerina/http;

# A service representing a network-accessible API
# bound to port `9090`.

type Album readonly & record {|
    string id;
    string title;
    string artist;
|};

table<Album> key(title) albums = table [
    {id: "1", title: "Blue Train", artist: "John Coltrane"},
    {id: "2", title: "Jeru", artist: "Gerry Mulligan"}
];

service / on new http:Listener(9090) {

    resource function get albums() returns Album[] {
        return albums.toArray();
    }

    resource function post albums(@http:Payload Album album) returns Album {
        albums.add(album);
        return album;
    }

    resource function get albums/[string id]() returns Album|http:NotFound {
        Album? album = albums[id];
        if album is () {
            return http:NOT_FOUND;
        }
        return album;
    }
}
