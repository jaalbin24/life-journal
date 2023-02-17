module EnglishLanguage
    def indefinite_articleize(args)
        if args[:word].nil?
            return
        end
        case args[:html_tag]
        when :strong, "strong"
            return %w(a e i o u).include?(args[:word][0].downcase) ? "an <strong>#{args[:word]}</strong>" : "a <strong>#{args[:word]}</strong>"
        end
        return %w(a e i o u).include?(args[:word][0].downcase) ? "an #{args[:word]}" : "a #{args[:word]}"
    end

    # def random_noun
    #     most_common_200_nouns = ["time","year","people","way","day","thing","information","work","business","service","life","company","site","world","part","system","student","child","program","number","place","lot","week","something","family","page","home","book","case","group","problem","product","school","community","area","member","website","experience","issue","project","state","user","month","question","woman","point","game","course","country","government","idea","event","process","name","use","result","man","example","money","datum","change","today","research","job","new","customer","post","team","right","level","friend","blog","order","person","fact","term","health","content","law","type","market","other","end","google","word","policy","development","value","university","food","medium","article","power","hour","support","line","technology","need","list","search","opportunity","cost","water","link","form","reason","study","application","report","tool","hand","activity","design","interest","plan","action","history","industry","organization","bit","option","client","story","someone","class","price","side","kind","rate","source","quality","web","education","U.S.","practice","comment","city","care","car","party","file","image","marketing","body","Internet","benefit","resource","effort","email","card","sale","video","room","United","access","solution","step","anything","minute","account","decision","network","house","view","version","everything","amount","management","night","model","space","goal","feature","effect","role","field","material","credit","everyone","software","training","office","mind","National","age","news","i","phone","York","skill","parent","individual","relationship","control","computer","risk","employee","show","music","energy"]
    #     most_common_200_nouns[rand(0..(most_common_200_nouns.length - 1))]
    # end

    # def random_adjective
    #     most_common_200_adjectives = ["good","other","more","new","many","first","great","such","own","few","same","high","last","most","different","small","large","important","next","big","little","old","social","able","available","online","free","long","easy","local","much","several","full","real","sure","public","possible","least","bad","personal","low","late","young","hard","current","only","right","second","early","special","simple","major","human","short","strong","true","open","whole","less","financial","common","due","top","past","various","certain","recent","single","political","clear","specific","main","particular","happy","similar","natural","interesting","national","American","private","international","difficult","effective","unique","professional","perfect","economic","additional","key","mobile","original","nice","medical","third","entire","likely","necessary","global","general","popular","successful","beautiful","wrong","significant","legal","enough","final","healthy","ready","huge","interested","wide","former","safe","close","traditional","amazing","future","individual","physical","basic","complete","positive","federal","digital","deep","potential","useful","regular","hot","further","previous","serious","multiple","extra","excellent","poor","responsible","wonderful","quick","modern","daily","active","critical","favorite","annual","powerful","total","creative","appropriate","green","worth","normal","actual","fresh","fine","direct","present","cheap","military","rich","primary","relevant","essential","environmental","aware","fast","cool","corporate","red","technical","overall","light","live","independent","commercial","complex","average","cultural","dark","sexual","foreign","standard","educational","awesome","expensive","numerous","clean","proper","cold","academic","heavy","mental","initial","central","video","negative","exciting"]
    #     most_common_200_adjectives[rand(0..(most_common_200_adjectives.length - 1))]
    # end

    def random_first_name
        most_common_100_first_names = ["Michael", "Christopher", "Jessica", "Matthew", "Ashley", "Jennifer", "Joshua", "Amanda", "Daniel", "David", "James", "Robert", "John", "Joseph", "Andrew", "Ryan", "Brandon", "Jason", "Justin", "Sarah", "William", "Jonathan", "Stephanie", "Brian", "Nicole", "Nicholas", "Anthony", "Heather", "Eric", "Elizabeth", "Adam", "Megan", "Melissa", "Kevin", "Steven", "Thomas", "Timothy", "Christina", "Kyle", "Rachel", "Laura", "Lauren", "Amber", "Brittany", "Danielle", "Richard", "Kimberly", "Jeffrey", "Amy", "Crystal", "Michelle", "Tiffany", "Jeremy", "Benjamin", "Mark", "Emily", "Aaron", "Charles", "Rebecca", "Jacob", "Stephen", "Patrick", "Sean", "Erin", "Zachary", "Jamie", "Kelly", "Samantha", "Nathan", "Sara", "Dustin", "Paul", "Angela", "Tyler", "Scott", "Katherine", "Andrea", "Gregory", "Erica", "Mary", "Travis", "Lisa", "Kenneth", "Bryan", "Lindsey", "Kristen", "Jose", "Alexander", "Jesse", "Katie", "Lindsay", "Shannon", "Vanessa", "Courtney", "Christine", "Alicia", "Cody", "Allison", "Bradley", "Samuel"]
        most_common_100_first_names[rand(0..(most_common_100_first_names.length - 1))]
    end

    def random_last_name
        most_common_100_last_names = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green", "Adams", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts", "Gomez", "Phillips", "Evans", "Turner", "Diaz", "Parker", "Cruz", "Edwards", "Collins", "Reyes", "Stewart", "Morris", "Morales", "Murphy", "Cook", "Rogers", "Gutierrez", "Ortiz", "Morgan", "Cooper", "Peterson", "Bailey", "Reed", "Kelly", "Howard", "Ramos", "Kim", "Cox", "Ward", "Richardson", "Watson", "Brooks", "Chavez", "Wood", "James", "Bennett", "Gray", "Mendoza", "Ruiz", "Hughes", "Price", "Alvarez", "Castillo", "Sanders", "Patel", "Myers", "Long", "Ross", "Foster", "Jimenez", "Powell"]
        most_common_100_last_names[rand(0..(most_common_100_last_names.length - 1))]
    end

    # def random_animal_name
    #     arbitrary_93_animal_names = ["alpaca", "ant", "antelope", "arctic wolf", "badger", "bald eagle", "bat", "bear", "bee", "bird", "bison", "buffalo", "butterfly", "camel", "cat", "cheetah", "chicken", "chimpanzee", "chipmunk", "cow", "coyote", "crab", "crocodile", "crow", "deer", "dog", "dolphin", "dove", "duck", "eagle", "earthworm", "elephant", "elk", "fish", "fish", "fox", "giraffe", "goat", "goose", "gorilla", "grasshopper", "hare", "hedgehog", "hen", "hippopotamus", "honey bee", "horse", "housefly", "kangaroo", "koala", "leopard", "lion", "lizard", "llama", "mole", "monkey", "mosquito", "mouse", "ostrich", "otter", "owl", "panda", "panther", "parrot", "peacock", "pig", "pigeon", "polar bear", "porcupine", "possum", "rabbit", "raccoon", "rat", "rattle snake", "red panda", "reindeer", "rhinoceros", "sabre-tooth cat", "sheep", "shrimp", "snake", "spider", "squirrel", "starfish", "tiger", "turkey", "walrus", "wild boar", "wolf", "wombat", "woodpecker", "woolly mammoth", "zebra"]        
    #     arbitrary_93_animal_names[rand(0..(arbitrary_93_animal_names.length - 1))]
    # end


    # Converts strings from CamelCase or snake_case to Sentence case
    # def sentence_case(str)
    #     str = str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1 \2')
    #     str = str.gsub(/([a-z\d])([A-Z])/, '\1 \2')
    #     str.gsub(/_/, ' ').split.map(&:capitalize).join(' ')
    # end
end

