json.partial! "lives/live", live: @live
json.songs @live.songs, partial: "songs/song", as: :song
