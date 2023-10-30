# This method is used to generate the journal entries. It is rather hacky, but it
# works well at seeding the database, and I haven't found a way to accomplish this with standard Rails methods.
def generate_content_for(entry)
  num_paragraphs = 20
  change_paragraph_has_image = 0.1
  content = Array.new(num_paragraphs) do
    # Create the entry's content paragraph-by-paragraph
    this_paragraph = Faker::Lorem.paragraph_by_chars(number: rand(50..500), supplemental: true)
    # Add the picture
    if rand(100) <= 100 * change_paragraph_has_image
      file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'entry_pictures')}/*").sample
      blob = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file_path),
        filename: File.basename(file_path),
        content_type: "image/#{File.extname(file_path).downcase}".gsub(".", "")
      )
      this_paragraph += %Q(<br><br><action-text-attachment sgid="#{blob.attachable_sgid}" caption="#{Faker::Lorem.sentences(number: rand(3..5)).join(" ")}" url="#{Rails.application.routes.url_helpers.rails_blob_url blob}"></action-text-attachment>)
    end
    this_paragraph
  end.reject(&:blank?).join("<br><br>")
  entry.update!(content: content)
end

# traits    = JSON.parse(File.read(Rails.root.join('db/seed_data/traits.json')))
quotes    = JSON.parse(File.read(Rails.root.join('db/seed_data/quotes.json')))
notes     = JSON.parse(File.read(Rails.root.join('db/seed_data/notes.json')))

# Sort traits.json by positivity rating
# File.open(Rails.root.join('db/seed_data/traits.json'), "w") do |file|
#   file.write("{\n")
#   sorted_traits = traits.sort_by {|k, v| v['positivity']}
#   file.write((sorted_traits.map {|k, v| "  \"#{k}\": {\n  \"positivity\": #{v['positivity']}\n  }"}).join(",\n"))
  
#   file.write("\n}")
# end

me = User.create(
  email: "j@example.com",
  password: "123"
)

quotes.each do |q|
  Quote.create(
    content: q['body'],
    author: (q['author'] unless q['author'].blank?),
    source: (q['source'] unless q['source'].blank?)
  )
end

# traits.each do |k, v|
#   Trait.create!(
#     word:       k,
#     positivity:   v['positivity'],
#     description:  Faker::Lorem.paragraphs(number: 2, supplemental: true).join("\n\n")
#   )
# end

100.times do
  biography = Array.new(rand(0..5)) { Faker::Lorem.paragraph_by_chars(number: rand(50..500), supplemental: true) }.join(" ")
  person = me.people.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    middle_name: (rand(0..9) <= 2 ? Faker::Name.first_name : nil),
    biography: biography,
    created_at: rand(0..372).days.ago
  )
  # rand(2..5).times do 
  #   person.personality.create!(
  #     trait: Trait.where.not(id: person.traits.pluck(:id)).sample
  #   )
  # end
  rand(10..20).times do
    person.notes.create!(
      content: notes.sample,
      user: me
    )
  end
  if true # rand(1..10) > 2
    file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample
    person.avatar.attach(io: File.open(file_path), filename: File.basename(file_path))
  end
  print "🧑"
end
# John Smith is always in the database. I test the search feature by searching for him.
me.people.create(
  first_name: "John",
  last_name: "Smith"
)
200.times do
  # Create the entry
  entry = me.entries.create!(
    status: (rand(0..9) == 0 ? 'draft' : 'published'),
    published_at: rand(0..365).days.ago,
    title: Faker::Lorem.sentence(word_count: 1, supplemental: true, random_words_to_add: 5)
  )
  generate_content_for(entry)

  # Create the mentions
  rand(1..7).times do
    entry.mentions.create!(
      person: Person.where.not(id: entry.people.pluck(:id)).sample
    )
    print "🗣️"
  end
  print "📗"
end

puts "Created #{ActionController::Base.helpers.pluralize User.count, 'user'}."          if User.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Entry.count, 'entry'}."        if Entry.count > 0
puts "-- #{Entry.published.count} published"                                            if Entry.published.count > 0
puts "-- #{ActionController::Base.helpers.pluralize Entry.drafts.count, 'draft'}"       if Entry.drafts.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Person.count, 'person'}."      if Person.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Mention.count, 'mention'}."    if Mention.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Trait.count, 'trait'}."        if Trait.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Quote.count, 'quote'}."        if Quote.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Note.count, 'note'}."          if Note.count > 0