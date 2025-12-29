const eslint = require('@eslint/js') // eslint-disable-line no-undef,@typescript-eslint/no-require-imports
const tseslint = require('typescript-eslint') // eslint-disable-line no-undef,@typescript-eslint/no-require-imports

// eslint-disable-next-line no-undef
module.exports = tseslint.config(
  eslint.configs.recommended,
  tseslint.configs.recommended,
  {
    ignores: ['**/build/**', '**/node_modules/**', '**/package-lock.json'],
  },
  {
    files: ['**/*.ts', '**/*.tsx'],
    languageOptions: {
      parser: tseslint.parser,
      parserOptions: {
        ecmaVersion: 2020,
        sourceType: 'module',
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
  }
)
