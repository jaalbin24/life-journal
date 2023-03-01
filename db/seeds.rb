# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'english_language'
include EnglishLanguage

me = User.create(
    email: "j@j.j",
    password: "123"
)

10.times do
    me.entries.create(
        published_at: 10.weeks.ago,
        title: "Eget gravida cum sociis natoque penatibus",
        text_content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vitae congue mauris rhoncus aenean vel elit scelerisque mauris pellentesque. Aliquet porttitor lacus luctus accumsan tortor posuere ac. Sit amet porttitor eget dolor morbi non arcu. A arcu cursus vitae congue mauris rhoncus aenean vel. Quis varius quam quisque id diam vel quam elementum pulvinar. Sem integer vitae justo eget magna fermentum iaculis eu non. Mauris rhoncus aenean vel elit scelerisque mauris. Nec dui nunc mattis enim ut tellus elementum. Massa placerat duis ultricies lacus sed turpis tincidunt id. Ac turpis egestas maecenas pharetra convallis posuere. Ipsum suspendisse ultrices gravida dictum.

        Pulvinar elementum integer enim neque volutpat ac. Nibh tortor id aliquet lectus proin nibh nisl. Neque laoreet suspendisse interdum consectetur libero. Metus dictum at tempor commodo ullamcorper a lacus vestibulum. Placerat vestibulum lectus mauris ultrices eros. Porttitor leo a diam sollicitudin tempor id eu nisl. Quis commodo odio aenean sed adipiscing diam. Purus semper eget duis at tellus at urna condimentum mattis. In ornare quam viverra orci. Praesent elementum facilisis leo vel. Vestibulum lorem sed risus ultricies tristique nulla aliquet enim. Cursus eget nunc scelerisque viverra. Gravida dictum fusce ut placerat. Felis donec et odio pellentesque diam volutpat commodo sed. Morbi tempus iaculis urna id volutpat lacus. Vulputate eu scelerisque felis imperdiet proin. Varius sit amet mattis vulputate enim nulla aliquet porttitor lacus. Adipiscing enim eu turpis egestas. Quis eleifend quam adipiscing vitae proin sagittis.
        
        Ac ut consequat semper viverra nam libero justo laoreet. Nam libero justo laoreet sit amet cursus sit amet. Consequat nisl vel pretium lectus quam id. Eu volutpat odio facilisis mauris. Pharetra et ultrices neque ornare aenean euismod. Eros in cursus turpis massa. Sit amet venenatis urna cursus eget nunc. Pretium viverra suspendisse potenti nullam ac tortor vitae. Sit amet massa vitae tortor condimentum. Erat nam at lectus urna duis convallis convallis.
        
        Bibendum ut tristique et egestas quis ipsum. Ultrices in iaculis nunc sed augue lacus viverra. Senectus et netus et malesuada fames ac turpis egestas sed. Nulla facilisi morbi tempus iaculis urna id volutpat. Aliquet sagittis id consectetur purus ut faucibus. Sit amet consectetur adipiscing elit ut aliquam purus sit. Euismod quis viverra nibh cras pulvinar mattis nunc. Et leo duis ut diam quam nulla porttitor. Ut porttitor leo a diam sollicitudin tempor id eu nisl. Mattis ullamcorper velit sed ullamcorper morbi tincidunt ornare massa eget. Neque volutpat ac tincidunt vitae semper quis lectus. Facilisi etiam dignissim diam quis enim lobortis scelerisque fermentum. Sed felis eget velit aliquet sagittis id consectetur purus ut. Condimentum vitae sapien pellentesque habitant morbi tristique. Sit amet mauris commodo quis imperdiet massa tincidunt.
        
        Mi quis hendrerit dolor magna eget est lorem ipsum. Odio morbi quis commodo odio aenean sed. Cras semper auctor neque vitae tempus quam pellentesque nec nam. Ultrices eros in cursus turpis massa tincidunt dui ut ornare. Ridiculus mus mauris vitae ultricies leo. Nulla porttitor massa id neque aliquam vestibulum morbi blandit cursus. Pellentesque habitant morbi tristique senectus. Egestas congue quisque egestas diam in arcu cursus euismod quis. Justo eget magna fermentum iaculis eu. Ullamcorper malesuada proin libero nunc consequat interdum varius sit. Habitasse platea dictumst vestibulum rhoncus est pellentesque elit ullamcorper. Laoreet suspendisse interdum consectetur libero id faucibus nisl tincidunt eget. Erat velit scelerisque in dictum non consectetur a erat nam. Scelerisque eleifend donec pretium vulputate sapien nec sagittis. Rhoncus aenean vel elit scelerisque mauris pellentesque pulvinar. At tellus at urna condimentum mattis pellentesque id nibh tortor. Arcu ac tortor dignissim convallis aenean et tortor at risus."
    )
end

20.times do
    Person.create(
        first_name: random_first_name,
        last_name:  random_last_name,
        age:        rand(18..90),
        sex:        'M',
    )
end

Entry.all.each do |e|
    rand(1..5).times do
        e.mentions.create(
            person: Person.all.sample
        )
    end
    e.picture_of_the_day.attach(io: File.open(Dir.glob("#{Rails.root.join('db', 'seed_data')}/*").sample), filename: 'potd.jpg')
end



puts "Created #{ActionController::Base.helpers.pluralize User.count, 'user'}."          if User.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Entry.count, 'entry'}."        if Entry.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Person.count, 'person'}."      if Person.count > 0
puts "Created #{ActionController::Base.helpers.pluralize Mention.count, 'mentions'}."   if Mention.count > 0
