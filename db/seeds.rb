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
milestones = JSON.parse(File.read(Rails.root.join('db/seed_data/milestones.json')))
lessons = JSON.parse(File.read(Rails.root.join('db/seed_data/lessons.json')))

File.open(Rails.root.join('db/seed_data/traits.json'), "w") do |file|
    file.write("{\n")
    sorted_traits = traits.sort_by {|k, v| v['positivity']}
    file.write((sorted_traits.map {|k, v| "  \"#{k}\": {\n    \"positivity\": #{v['positivity']}\n  }"}).join(",\n"))
    
    file.write("\n}")
end


# me = User.create(
#     email: "j@j.j",
#     password: "123"
# )

# quotes.each do |q|
#     Quote.create(
#         content: q['body'],
#         author: (q['author'] unless q['author'].blank?)
#     )
# end

# 25.times do
#     entry = me.entries.create!(
#         status: (rand(0..9) == 0 ? 'draft' : 'published'),
#         published_at: rand(5..1000).days.ago,
#         title: Faker::Lorem.sentence(word_count: 1, supplemental: true, random_words_to_add: 5),
#         text_content: Faker::Lorem.paragraphs(number: 16, supplemental: true).join("\n\n")
#     )
#     10.times do
#         entry.milestones.create!(
#             content: milestones.sample,
#             reached_at: entry.created_at,
#             user: entry.author
#         )
#     end
#     10.times do
#         entry.lessons.create!(
#             user: me,
#             content: lessons.sample
#         )
#     end
# end

# # milestones.each do |m|
# #     entry = Entry.all.sample if rand(0..9) < 4
# #     if entry
# #         entry.milestones.create(
# #             content: m,
# #             reached_at: entry.created_at,
# #         )
# #     else
# #         Milestone.create(
# #             content: m,
# #             reached_at: rand(0..18250).days.ago,
# #         )
# #     end
# # end

# traits.each do |k, v|
#     Trait.create!(
#         word:           k,
#         score:          v['score'],
#         description:    Faker::Lorem.paragraphs(number: 2, supplemental: true).join("\n\n")
#     )
# end

# 20.times do
#     person = me.people.create!(
#         first_name: Faker::Name.first_name,
#         last_name:  Faker::Name.last_name,
#     )
#     rand(2..5).times do 
#         person.personality.create!(
#             trait: Trait.where.not(id: person.traits.pluck(:id)).sample
#         )
#     end
#     if rand(1..10) > 2
#         file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample
#         person.avatar.attach(io: File.open(file_path), filename: File.basename(file_path))
#     end
# end

# Entry.all.each do |e|
#     rand(1..5).times do
#         e.mentions.create!(
#             person: Person.where.not(id: e.people.pluck(:id)).sample
#         )
#     end
#     rand(2..6).times do
#         picture = e.pictures.create!(
#             description: Faker::Lorem.sentences(number: rand(3..5)).join(" ")
#         )
#         file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'entry_pictures')}/*").sample
#         picture.file.attach(io: File.open(file_path), filename: File.basename(file_path))
#     end
# end

# Person.all.each do |p|
#     rand(2..10).times do
#         p.lessons.create!(
#             user: me,
#             content: lessons.sample
#         )
#     end
# end

# puts "Created #{ActionController::Base.helpers.pluralize User.count, 'user'}."              if User.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Entry.count, 'entry'}."            if Entry.count > 0
# puts "-- #{Entry.published.count} published"                                                if Entry.published.count > 0
# puts "-- #{ActionController::Base.helpers.pluralize Entry.drafts.count, 'draft'}"           if Entry.drafts.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Person.count, 'person'}."          if Person.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Mention.count, 'mention'}."        if Mention.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Trait.count, 'trait'}."            if Trait.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Quote.count, 'quote'}."            if Quote.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Lesson.count, 'lesson'}."          if Lesson.count > 0
# puts "Created #{ActionController::Base.helpers.pluralize Milestone.count, 'milestone'}."    if Milestone.count > 0