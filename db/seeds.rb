# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Destroying all ingredients'
Ingredient.destroy_all if Rails.env.development?

puts 'Destroying all Cocktails'
Cocktail.destroy_all if Rails.env.development?

puts 'Creating ingredients'
url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
user_serialized = open(url).read
ingredients = JSON.parse(user_serialized)
ingredients['drinks'].each do |ingredient|
  i = Ingredient.create(name: ingredient['strIngredient1'])
  puts "create #{i.name}"
end

puts 'Creating random Doses'

10.times do
  file = URI.open('https://images.unsplash.com/photo-1575650772417-e6b418b0d106?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80')
  cocktail = Cocktail.create(name: Faker::Beer.unique.name, description: Faker::Lorem.sentence(word_count: 12, supplemental: true))

  puts 'Adding image to cocktail'

  cocktail.photo.attach(io: file, filename: 'cocktail-img.png', content_type: 'image/png')
  3.times do
    ingredient = Ingredient.find(Faker::Number.within(range: 1..100))
    cocktail.doses.create(description: "#{Faker::Number.within(range: 10..40)}cl", cocktail_id: cocktail.id, ingredient_id: ingredient.id)
  end
end
