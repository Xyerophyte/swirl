# Contributing to SWIRL

First off, thank you for considering contributing to SWIRL! It's people like you that make SWIRL such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the issue list as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

* **Use a clear and descriptive title**
* **Describe the exact steps to reproduce the problem**
* **Provide specific examples**
* **Describe the behavior you observed and what you expected**
* **Include screenshots if possible**
* **Include your environment details** (Flutter version, device, OS)

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion, please include:

* **Use a clear and descriptive title**
* **Provide a detailed description of the suggested enhancement**
* **Explain why this enhancement would be useful**
* **List any alternative solutions you've considered**

### Pull Requests

* Fill in the required template
* Follow the Flutter style guide
* Include tests when adding new features
* Update documentation as needed
* End all files with a newline

## Development Process

### 1. Fork & Clone

```bash
git clone https://github.com/yourusername/swirl.git
cd swirl/swirl
```

### 2. Create a Branch

```bash
git checkout -b feature/amazing-feature
```

### 3. Make Changes

* Write clean, readable code
* Follow existing code style
* Add tests for new functionality
* Update documentation

### 4. Test Your Changes

```bash
flutter test
flutter analyze
```

### 5. Commit Your Changes

```bash
git add .
git commit -m "feat: add amazing feature"
```

Use conventional commit messages:
* `feat:` - New feature
* `fix:` - Bug fix
* `docs:` - Documentation changes
* `style:` - Code style changes (formatting)
* `refactor:` - Code refactoring
* `test:` - Adding tests
* `chore:` - Maintenance tasks

### 6. Push to Your Fork

```bash
git push origin feature/amazing-feature
```

### 7. Open a Pull Request

* Use a clear title and description
* Reference any related issues
* Include screenshots for UI changes
* Ensure all tests pass

## Style Guide

### Dart/Flutter Code Style

* Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) style guide
* Use `flutter format` before committing
* Maximum line length: 80 characters
* Use meaningful variable names
* Add comments for complex logic

### File Organization

```
lib/
├── core/           # Core utilities, theme, constants
├── features/       # Feature modules (one per screen/function)
├── data/          # Models, repositories, services
└── shared/        # Shared widgets
```

### Widget Guidelines

* Keep widgets small and focused
* Extract reusable components
* Use const constructors when possible
* Prefer composition over inheritance

### State Management

* Use Riverpod for state management
* Keep providers in the feature they belong to
* Use code generation for providers when appropriate

## Testing Guidelines

* Write unit tests for business logic
* Write widget tests for UI components
* Write integration tests for critical flows
* Aim for >80% code coverage

## Documentation

* Update README.md if needed
* Document public APIs
* Add inline comments for complex logic
* Update CHANGELOG.md

## Review Process

1. CI/CD checks must pass
2. Code review by at least one maintainer
3. All feedback addressed
4. No merge conflicts
5. Branch up to date with main

## Community

* Join our [Discord](https://discord.gg/swirl)
* Follow us on [Twitter](https://twitter.com/SwirlApp)
* Read our [Blog](https://blog.swirlapp.com)

## Questions?

Feel free to:
* Open a discussion on GitHub
* Ask in our Discord server
* Email us at dev@swirlapp.com

Thank you for contributing! 🎉