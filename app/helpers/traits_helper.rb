module TraitsHelper
    def color_class(trait)
        if trait.positivity.in?(-100..-80)
            'trait-0'
        elsif trait.positivity.in?(-79..-60)
            'trait-10'
        elsif trait.positivity.in?(-59..-40)
            'trait-20'
        elsif trait.positivity.in?(-39..-20)
            'trait-30'
        elsif trait.positivity.in?(-19..0)
            'trait-40'
        elsif trait.positivity.in?(1..20)
            'trait-50'
        elsif trait.positivity.in?(21..40)
            'trait-60'
        elsif trait.positivity.in?(41..60)
            'trait-70'
        elsif trait.positivity.in?(61..80)
            'trait-80'
        elsif trait.positivity.in?(81..100)
            'trait-90'
        end
    end
end