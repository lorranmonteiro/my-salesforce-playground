export default [
  {
    ignores: [
      'jest.config.js',
      'force-app/main/default/staticresources'
    ]
  },
  {
    files: ['**/*.js'],
    rules: {
      '@lwc/lwc-platform/no-inline-disable': 'off',
    }
  }
];