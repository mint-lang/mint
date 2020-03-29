message InstallerFailedToInstall do
  title "Install Error"

  block do
    text "Failed to satisfy the following constraint:"
  end

  block do
    bold "#{name} #{constraint}"
    text "from"
    bold package
  end

  eliminated = @data["eliminated"]?

  case eliminated
  when Array(String)
    unless eliminated.empty?
      block do
        text "All versions of"
        bold name
        text "were eliminated:"
      end

      list eliminated

      block do
        text "There are no version available for:"
        bold name
      end
    end
  end
end
