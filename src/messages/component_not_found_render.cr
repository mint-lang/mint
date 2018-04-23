message ComponentNotFoundRender do
	title "Type Error"

	block do
		text "A component must have a"
		bold "render"
		text "function."
	end

	snippet node, "This component does not have one:"
end
