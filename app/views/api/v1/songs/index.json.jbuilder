json.array! @songs do |song|
  json.cache_if! !authenticated?, ["v1", song] do
    json.partial! "api/v1/songs/song", song: song
    json.live song.live, partial: "api/v1/lives/live", as: :live
  end
end
