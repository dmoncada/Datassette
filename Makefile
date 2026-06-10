format:
	@swift format \
		--ignore-unparsable-files \
		--in-place \
		--parallel \
		--recursive \
		./Datassette

build:
	@echo "Building Datassette for iOS..."
	@xcodebuild build \
		-project Datassette.xcodeproj \
		-scheme Datassette \
		-destination 'generic/platform=iOS Simulator' \
		CODE_SIGN_IDENTITY='' \
		CODE_SIGN_STYLE='Automatic' \
		| xcbeautify

.PHONY: format build
