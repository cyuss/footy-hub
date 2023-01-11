# Makefile

.DEFAULT_GOAL := help


help:
	@echo "AVAILABLE COMMANDS"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf " \033[36m%-30s\033[0m %s\n", $$1, $$2}'

devmoji: ## Init devmoji (add emojis to commit messages). Install it with `npm install -g devmoji`.
	@cp .git/hooks/prepare-commit-msg.sample .git/hooks/prepare-commit-msg
	@echo "#!/bin/sh\n\nCOMMIT_MSG_FILE=\$$1\nCOMMIT_MSG=\$$(cat \$$COMMIT_MSG_FILE)\n\necho \"\$${COMMIT_MSG}\" | devmoji > \$$1" > .git/hooks/prepare-commit-msg

doc: ## Generate MkDocs documentation and serve.
	@poetry run mkdocs new .
	@poetry run mkdocs serve

start: ## Start the API locally.
	@poetry run python main.py

test: ## Run unit tests.
	@poetry run pytest --disable-pytest-warnings
	@echo "The tests pass! ✨ 🍰 ✨"

coverage: ## Run coverage tests.
	@poetry run pytest --cov=. --disable-pytest-warnings
	@echo "The tests pass! ✨ 🍰 ✨"

lock: ## Generate `poetry.lock` file for dependencies.
	@poetry lock

reqs: ## Generate a requirements.txt file.
	@poetry export --without-hashes -f requirements.txt -o requirements.txt

reqs_dev: ## Generate a requirements_dev.txt file.
	@poetry export --with dev,test --without-hashes -f requirements.txt -o requirements_dev.txt

cloc: ## Count blank lines, comment lines, and physical lines of source code.
	@poetry run cloc --exclude-dir .venv,.DS_Store --exclude-ext gif,pyc .

code_metrics: ## Compute various metrics from the source code (code quality).
	@poetry run radon cc mi hal . -a -na -s

format: ## Format the source code using black.
	@poetry run black .
	@poetry run isort .

format_check: ## Check what to change using black.
	@poetry run black --check .

lint: ## Lint the source code using Ruff.
	@poetry run black .
	@poetry run ruff -e --fix .

mypy: ## Run mypy for data type check
	@poetry run mypy .

performance: ## Profiling source code.
	@poetry run pyinstrument main.py

clean: ## Delete unwanted files.
	@rm -rf `find . -name __pycache__`
	@rm -rf `find . -name .pytest_cache`
	@rm -rf `find . -name .ipynb_checkpoints`
	@rm -rf `find . -name .DS_Store`
	@rm -rf outputs
	@rm -f `find . -type f -name '*.py[co]' `
	@rm -f `find . -type f -name '*~' `
	@rm -f `find . -type f -name '.*~' `
	@rm -rf `find . -type d -name '*.egg-info' `
	@rm -rf `find . -type d -name 'pip-wheel-metadata' `
	@rm -rf `find . -type d -name 'tmp*' `
	@rm -rf .DS_Store
	@rm -rf .cache
	@rm -rf .pytest_cache
	@rm -rf .mypy_cache
	@rm -rf htmlcov
	@rm -rf *.egg-info
	@rm -f .coverage
	@rm -f .coverage.*
	@rm -rf generated
	@rm -f `find . -name '*.pyc'`
	@rm -f `find . -name '*.pyo'`
	@rm -f `find . -name '*~'`
	@echo "Your repo is clean! 👌🏼 ✨"
