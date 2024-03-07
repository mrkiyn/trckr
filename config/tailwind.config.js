const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*',
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        'pal': {
          100: '#1B2024ff',
          200: '#272B30ff',
          300: '#292730ff',
          400: '#3E3331ff',
          500: '#FD3F39ff',
          600: '#FEBD28ff',
          700: '#0077F3ff',
          800: '#579E51ff',
        },
      },
      spacing: {
        '1/2': '50%',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
