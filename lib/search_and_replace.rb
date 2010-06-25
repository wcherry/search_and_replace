require 'search_and_replace_dialog'

module Redcar
  # This class implements the search-and-replace command
  class SearchAndReplace
  
	# method to return a valid shell for the dialog to bind to: This code is in the core but duplicated here
	# TODO: This method may be removed if we can call the equivlant method in the core.
    def self.parent_shell
      if focussed_window = Redcar.app.focussed_window
        focussed_window.controller.shell
      else
        Redcar.app.controller.fake_shell
      end
    end
  
    # Create the search and replace menu item
    def self.menus
      # Here's how the plugin menus are drawn. Try adding more
      # items or sub_menus.
      Menu::Builder.build do
        sub_menu "Edit" do
          item "Search and Replace", SearchAndReplaceCommand
        end
      end
    end

    # Search-and-Replace command.
    class SearchAndReplaceCommand < Redcar::Command
      # The execution reuses the same dialog.
	  def execute
        @@dialog ||= @@dialog = SearchAndReplaceDialog.new(SearchAndReplace::parent_shell, "test")
        @@dialog.searchTerms = ["foo", "bar", "alpha", "gama"]
        @@dialog.replaceTerms = ["A", "B", "C", "D"]
        @@dialog.open()
        if(@@dialog.replace_type != SearchAndReplaceDialog::CANCEL) 
          puts("Replacing #{@@dialog.replace_type == SearchAndReplaceDialog::REPLACE_ALL ? 'all ':''} #{@@dialog.search} with #{@@dialog.replace}")
        end
        
      end
    end
  end
end