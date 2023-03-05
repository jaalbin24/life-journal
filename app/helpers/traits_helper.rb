module TraitsHelper
    def color_class(trait)
        if trait.score.in?(1..10)
            'trait-0'
        elsif trait.score.in?(11..20)
            'trait-10'
        elsif trait.score.in?(21..30)
            'trait-20'
        elsif trait.score.in?(31..40)
            'trait-30'
        elsif trait.score.in?(41..50)
            'trait-40'
        elsif trait.score.in?(51..60)
            'trait-50'
        elsif trait.score.in?(61..70)
            'trait-60'
        elsif trait.score.in?(71..80)
            'trait-70'
        elsif trait.score.in?(81..90)
            'trait-80'
        elsif trait.score.in?(91..100)
            'trait-90'
        end
    end
end