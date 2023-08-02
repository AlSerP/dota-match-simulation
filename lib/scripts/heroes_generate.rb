require 'json'

hash_as_string = File.open('../src/json/heroes_api.json').read
data = JSON.parse hash_as_string

heroes = {}

data.each do |hero|
    heroes[hero['id']] = {name: hero['localized_name']}
end 


File.open('../src/json/heroes.json', 'w') do |f|
    f.write(heroes.to_json)
end
