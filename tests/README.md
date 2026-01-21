# WardenGUI Unit Tests

This directory contains unit tests for the WardenGUI headless features.

## Test Files

- `test_headless.py` - Tests for headless mode functionality (start, info commands)
- `test_warden_mocking.py` - Tests for WardenManager with mocked Docker commands

## Running Tests

### Using unittest (built-in)

```bash
# Run all tests
python3 -m unittest discover -s tests -p "test_*.py" -v

# Run specific test file
python3 -m unittest tests.test_headless -v
python3 -m unittest tests.test_warden_mocking -v

# Run specific test class
python3 -m unittest tests.test_headless.TestHeadlessFeatures -v

# Run specific test method
python3 -m unittest tests.test_headless.TestHeadlessFeatures.test_find_project_by_name_found -v
```

### Using pytest (optional)

If you have pytest installed:

```bash
# Install pytest
pip install pytest pytest-cov

# Run all tests
pytest tests/ -v

# Run with coverage
pytest tests/ --cov=src/wardengui --cov-report=html
```

## Test Coverage

The tests cover:

### Headless Features (`test_headless.py`)
- Finding projects by name
- Starting environments (already running, stop current then start, failures)
- Showing environment info (found, not found)
- Error handling and exit codes
- Main function headless mode integration
- Full flow with mocked WardenManager

### WardenManager Mocking (`test_warden_mocking.py`)
- Docker command mocking (ps, volume ls, etc.)
- Environment operations (start, stop, restart)
- Command result parsing
- URL generation
- Command string generation

## Mocking Strategy

The tests use `unittest.mock` to mock:
- `WardenManager` methods (get_projects, get_running_environment, etc.)
- `subprocess.run` calls for Docker commands
- UI functions (start_environment_ui, stop_environment_ui, _print_project_details)
- System functions (sys.exit, sys.argv)

This ensures tests run quickly without requiring actual Docker or Warden installations.

## Example Test Output

```
test_find_project_by_name_found ... ok
test_find_project_by_name_not_found ... ok
test_start_environment_core_already_running ... ok
test_start_environment_core_stop_current_then_start ... ok
test_headless_start_success ... ok
test_headless_start_env_not_found_exits ... ok
...
```

## Adding New Tests

When adding new headless features:

1. Add tests to `test_headless.py` for CLI-level functionality
2. Add tests to `test_warden_mocking.py` for WardenManager-level functionality
3. Mock external dependencies (Docker, file system, etc.)
4. Test both success and failure cases
5. Verify exit codes for headless mode failures
