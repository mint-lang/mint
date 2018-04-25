message CssDefinitionExpectedColon do
	title "Syntax Error"

	block do
		text "A CSS property and its value must be separated by a"
		bold "colon"
		code ":"
	end

	was_looking_for "colon", got, ":"

	snippet node
end
