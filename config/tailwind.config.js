const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
  ],
  theme: {
    extend: {
      // 7 rows for the year-long entry history map
      gridTemplateRows: {
        '7': 'repeat(7, minmax(0, 1fr))',
      },
      // 53 columns for the year-long entry history map
      gridTemplateColumns: {
        '55': 'repeat(55, minmax(0, 1fr))',
        '53': 'repeat(53, minmax(0, 1fr))',
      },
      gridRow: {
        'span-8': 'span 8 / span 8',
      },
      gridColumn: {
        'span-53': 'span 53 / span 53',
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      scale: {
        '101': '1.01',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}