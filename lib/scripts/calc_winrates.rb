require 'json'

hash_as_string = File.open("../src/json/heroes_vs_heroes.json").read
data = JSON.parse hash_as_string

winrates = {}

data.keys.each do |hero_id|
    winrates[hero_id] = {}
    data[hero_id].keys.each do |enemy_id|
        wins = data[hero_id][enemy_id][7]['wins'] + data[hero_id][enemy_id][6]['wins']
        matches = data[hero_id][enemy_id][7]['matches'] + data[hero_id][enemy_id][6]['matches']
        winrates[hero_id][enemy_id] = wins.to_f / matches
    end
end


File.open('../src/json/winrates.json', 'w') do |f|
    f.write(winrates.to_json)
end
