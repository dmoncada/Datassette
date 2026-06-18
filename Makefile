SWIFT := "/usr/bin/swift"

check:
	@$(SWIFT) format \
		lint \
		--strict \
		--parallel \
		--recursive \
		./Datassette

format:
	@$(SWIFT) format \
		--ignore-unparsable-files \
		--in-place \
		--parallel \
		--recursive \
		./Datassette

build:
	@echo "Building Datassette for iOS..."
	@xcodebuild build \
		CODE_SIGN_IDENTITY='' \
		CODE_SIGN_STYLE='Automatic' \
		-project Datassette.xcodeproj \
		-scheme Datassette \
		-destination 'generic/platform=iOS Simulator' \
		| xcbeautify

.PHONY: format build
