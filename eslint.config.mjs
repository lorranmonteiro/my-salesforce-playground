export default [
  {
    ignores: [
      'jest.config.js',
      'force-app/main/default/staticresources',
      'force-app/main/default/uiBundles/myReactApp'
    ]
  },
  {
    files: ['**/*.js'],
    rules: {
      '@lwc/lwc-platform/no-inline-disable': 'off',
    }
  }
];
