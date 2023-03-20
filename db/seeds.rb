# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'english_language'
include EnglishLanguage

traits = JSON.parse(File.read(Rails.root.join('db/seed_data/traits.json')))
quotes = JSON.parse(File.read(Rails.root.join('db/seed_data/quotes.json')))

me = User.create(
    email: "j@j.j",
    password: "123"
)

quotes.each do |q|
    Quote.create(
        content: q['body'],
        author: (q['author'] unless q['author'].blank?)
    )
end

100.times do
    me.entries.create!(
        published_at: rand(5..1000).days.ago,
        title: Faker::Lorem.sentence(word_count: 1, supplemental: true, random_words_to_add: 5),
        text_content: Faker::Lorem.paragraphs(number: 16, supplemental: true).join("\n\n")
    )
end

traits.each do |k, v|
    Trait.create!(
        word:           k,
        score:          v['score'],
        description:    Faker::Lorem.paragraphs(number: 2, supplemental: true).join("\n\n")
    )
end

20.times do
    person = me.people.create!(
        first_name: Faker::Name.first_name,
        last_name:  Faker::Name.last_name,
    )
    rand(2..5).times do 
        person.personality.create!(
            trait: Trait.where.not(id: person.traits.pluck(:id)).sample
        )
    end
    if rand(1..10) > 2
        file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample
        person.avatar.attach(io: File.open(file_path), filename: File.basename(file_path))
    end
end

Entry.all.each do |e|
    rand(1..5).times do
        e.mentions.create!(
            person: Person.where.not(id: e.people.pluck(:id)).sample
        )
    end
    rand(0..3).times do
        picture = e.pictures.create!(
            description: Faker::Lorem.sentences(number: rand(1..5)).join(" ")
        )
        file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'entry_pictures')}/*").sample
        picture.file.attach(io: File.open(file_path), filename: File.basename(file_path))
    end
end

Person.all.each do |p|
    rand(2..10).times do
        p.lessons.create!(
            user: me,
            content: Faker::Quote.yoda
        )
    end
end

puts "Created #{ActionController::Base.helpers.pluralize User.count, 'user'}."          if User.count       > 0
puts "Created #{ActionController::Base.helpers.pluralize Entry.count, 'entry'}."        if Entry.count      > 0
puts "Created #{ActionController::Base.helpers.pluralize Person.count, 'person'}."      if Person.count     > 0
puts "Created #{ActionController::Base.helpers.pluralize Mention.count, 'mention'}."    if Mention.count    > 0
puts "Created #{ActionController::Base.helpers.pluralize Trait.count, 'trait'}."        if Trait.count      > 0
puts "Created #{ActionController::Base.helpers.pluralize Quote.count, 'quote'}."        if Quote.count      > 0
puts "Created #{ActionController::Base.helpers.pluralize Lesson.count, 'lesson'}."      if Lesson.count      > 0