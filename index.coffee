audiosprite = require 'audiosprite'
jsonfile    = require 'jsonfile'
jsonfile.spaces = 2

# Loop through all the episodes and generate the sprite
go = () ->
  for episodeNum in [0..5]
    manifest = require "./manifests/ep#{episodeNum}.json"
    buildChapterSprites manifest, episodeNum

buildChapterSprites = ( manifest, episode ) ->
  for chapterNum, chapter of manifest.chapters

    dir   = "./sprites/episode#{episode}"
    files = []
    opts  =
      output  : "#{dir}/chapter#{chapterNum}/sprite"
      gap     : 0.25
      format  : 'howler'
      export  : 'mp3'
      bitrate : 96

    for item in chapter.mp3s
      files.push "./" + item.src

    createFiles files, opts, chapterNum, dir, manifest


createFiles = (files, opts, chapterNum, dir, manifest) ->

  audiosprite files, opts, (err, obj) ->
    if (err) then return console.error err

    for key, spriteItem of obj.sprite
      for file in manifest.chapters['1'].mp3s
        if file.id.indexOf(key) > -1
          obj.sprite[file.id] = spriteItem
          delete obj.sprite[key]
          break

    console.log chapterNum
    jsonfile.writeFile "#{dir}/chapter#{chapterNum}/sprite.json", obj, (err)-> console.error(err)


go()