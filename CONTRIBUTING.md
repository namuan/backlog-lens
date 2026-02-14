# Contributing to JIRA Backlog Intelligence Platform

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to this project.

## 🚀 Quick Start

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/backlog-lens.git`
3. Create a branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes: `make test`
6. Commit your changes: `git commit -m "Add feature X"`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Create a Pull Request

## 📋 Development Setup

### Prerequisites

- Docker and Docker Compose
- Git
- (Optional) Python 3.11+ for local backend development
- (Optional) Node.js 18+ for local frontend development

### Local Development

#### Using Docker (Recommended)

```bash
# Start all services
make up-logs

# Or use docker-compose directly
docker-compose up --build
```

#### Backend Only (Python)

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt

# Set environment variables
export DATABASE_URL="postgresql://jira:changeme@localhost:5432/jira_intel"
export ENCRYPTION_KEY="your-key-here"
export JWT_SECRET="your-secret-here"

# Run
uvicorn app.main:app --reload
```

#### Frontend Only (React)

```bash
cd frontend
npm install
npm start
```

## 🧪 Testing

### Manual Testing

See [TESTING.md](TESTING.md) for detailed manual testing procedures.

### Automated Tests

```bash
# Run basic smoke tests
make test

# Backend tests (TODO - to be implemented)
cd backend
pytest

# Frontend tests (TODO - to be implemented)
cd frontend
npm test
```

## 📝 Code Style

### Python (Backend)

- Follow PEP 8 style guide
- Use type hints where appropriate
- Add docstrings to functions and classes
- Keep functions small and focused

Example:
```python
def process_user_data(user_id: UUID, data: dict) -> UserResponse:
    """Process user data and return response.
    
    Args:
        user_id: The UUID of the user
        data: Dictionary containing user data
        
    Returns:
        UserResponse object with processed data
    """
    # Implementation
    pass
```

### TypeScript/React (Frontend)

- Use TypeScript for all new code
- Follow React best practices
- Use functional components with hooks
- Add proper types to props and state

Example:
```typescript
interface UserProps {
  userId: string;
  onUpdate: (data: UserData) => void;
}

const UserComponent: React.FC<UserProps> = ({ userId, onUpdate }) => {
  // Implementation
};
```

### SQL

- Use uppercase for SQL keywords
- Include comments for complex queries
- Use meaningful table and column names
- Add indexes for performance

## 🔍 Pull Request Guidelines

### Before Submitting

- [ ] Code follows the project's style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated if needed
- [ ] Commit messages are clear and descriptive
- [ ] No unnecessary files included (check .gitignore)

### PR Description Template

```markdown
## Description
Brief description of what this PR does

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How was this tested?

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 🐛 Bug Reports

When reporting bugs, please include:

1. **Description**: Clear description of the bug
2. **Steps to Reproduce**: Step-by-step instructions
3. **Expected Behavior**: What should happen
4. **Actual Behavior**: What actually happens
5. **Environment**: OS, Docker version, browser (if frontend)
6. **Screenshots**: If applicable
7. **Logs**: Relevant error messages or logs

## 💡 Feature Requests

When requesting features:

1. **Use Case**: Describe the problem you're trying to solve
2. **Proposed Solution**: How would you like it to work?
3. **Alternatives**: Any alternative solutions you've considered
4. **Additional Context**: Screenshots, mockups, or examples

## 📚 Project Structure

```
backlog-lens/
├── backend/               # FastAPI backend
│   ├── app/
│   │   ├── api/          # API endpoints
│   │   ├── core/         # Core functionality (config, db, security)
│   │   ├── models/       # SQLAlchemy models
│   │   ├── schemas/      # Pydantic schemas
│   │   ├── services/     # Business logic
│   │   └── workers/      # Background workers
│   └── requirements.txt
├── frontend/             # React frontend
│   ├── src/
│   │   ├── pages/       # Page components
│   │   ├── components/  # Reusable components
│   │   └── services/    # API services
│   └── package.json
├── database/
│   └── migrations/      # SQL migrations
└── docker-compose.yml
```

## 🔄 Development Workflow

1. **Pick an Issue**: Look for issues tagged with `good first issue` or `help wanted`
2. **Discuss**: Comment on the issue to discuss approach
3. **Implement**: Create a branch and implement your changes
4. **Test**: Ensure all tests pass and add new tests
5. **Document**: Update documentation if needed
6. **Submit PR**: Create a pull request with a clear description
7. **Review**: Address any feedback from reviewers
8. **Merge**: Once approved, your PR will be merged

## 🎯 Areas That Need Help

- [ ] Implement JIRA API integration
- [ ] Build similarity analysis engine
- [ ] Create background job worker
- [ ] Add comprehensive test coverage
- [ ] Improve UI/UX
- [ ] Write documentation
- [ ] Performance optimization
- [ ] Security enhancements

## 📞 Getting Help

- **Documentation**: Check [README.md](README.md) and [PLAN.md](PLAN.md)
- **Issues**: Search existing issues or create a new one
- **Discussions**: Use GitHub Discussions for questions

## 📄 License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to make this project better! 🎉
