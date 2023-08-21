traits    = JSON.parse(File.read(Rails.root.join('db/seed_data/traits.json')))
quotes    = JSON.parse(File.read(Rails.root.join('db/seed_data/quotes.json')))
notes     = JSON.parse(File.read(Rails.root.join('db/seed_data/notes.json')))

# Sort traits.json by positivity rating
File.open(Rails.root.join('db/seed_data/traits.json'), "w") do |file|
  file.write("{\n")
  sorted_traits = traits.sort_by {|k, v| v['positivity']}
  file.write((sorted_traits.map {|k, v| "  \"#{k}\": {\n  \"positivity\": #{v['positivity']}\n  }"}).join(",\n"))
  
  file.write("\n}")
end

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

traits.each do |k, v|
  Trait.create!(
    word:       k,
    positivity:   v['positivity'],
    description:  Faker::Lorem.paragraphs(number: 2, supplemental: true).join("\n\n")
  )
end

50.times do
  person = me.people.create!(
    first_name: Faker::Name.first_name,
    last_name:  Faker::Name.last_name,
    middle_name: (rand(0..9) <= 2 ? Faker::Name.first_name : nil),
    biography: nil
  )
  rand(2..5).times do 
    person.personality.create!(
      trait: Trait.where.not(id: person.traits.pluck(:id)).sample
    )
  end
  rand(10..20).times do
    person.notes.create!(
      content: notes.sample,
      user: me
    )
  end
  if rand(1..10) > 2
    file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample
    person.avatar.attach(io: File.open(file_path), filename: File.basename(file_path))
  end
end
25.times do
  me.people.create(
    first_name: "John",
    last_name: "Smith"
  )
end

24.times do
  content = Array.new(rand(4..20)) do
    Faker::Lorem.paragraph_by_chars(number: rand(50..500), supplemental: true)
  end
  entry = me.entries.create!(
    status: (rand(0..9) == 0 ? 'draft' : 'published'),
    published_at: rand(5..1000).days.ago,
    title: Faker::Lorem.sentence(word_count: 1, supplemental: true, random_words_to_add: 5),
    content: ActionText::Content.new(content.join("<br><br>"))
  )
  rand(1..5).times do
    entry.mentions.create!(
      person: Person.where.not(id: entry.people.pluck(:id)).sample
    )
  end
  rand(2..6).times do
    picture = entry.pictures.build(
      description: Faker::Lorem.sentences(number: rand(3..5)).join(" "),
      title: Faker::Fantasy::Tolkien.poem,
      user: me
    )
    file_path = Dir.glob("#{Rails.root.join('db', 'seed_data', 'entry_pictures')}/*").sample
    picture.file.attach(io: File.open(file_path), filename: File.basename(file_path))
    picture.save!
  end
end

puts "Created #{ActionController::Base.helpers.pluralize User.count, 'user'}."        if User.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Entry.count, 'entry'}."      if Entry.count > 0
puts "-- #{Entry.published.count} published"                        if Entry.published.count > 0
puts "-- #{ActionController::Base.helpers.pluralize Entry.drafts.count, 'draft'}"       if Entry.drafts.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Picture.count, 'picture'}."    if Picture.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Person.count, 'person'}."      if Person.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Mention.count, 'mention'}."    if Mention.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Trait.count, 'trait'}."      if Trait.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Quote.count, 'quote'}."      if Quote.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Note.count, 'note'}."        if Note.count > 0