message ComponentRenderTypeMismatch do
	title "Type Error"

	block do
		text "I was expecting the return value of the"
		bold "render"
		text "function to match one of these types:"
	end

	pre "Html, String, Array(String), Array(Html)"

	type_with_text got, "Instead it is:"

	snippet node, "The render function in question:"
end
