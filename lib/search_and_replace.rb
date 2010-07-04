module Redcar
  # This class implements the search-and-replace command
  class SearchAndReplace
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
    class SearchAndReplaceCommand < Redcar::EditTabCommand
      # The execution reuses the same dialog.
	    def execute
        @speedbar = SearchAndReplaceSpeedbar.new
        win.open_speedbar(@speedbar)
      end
    end
  end

  class SearchAndReplaceSpeedbar < Redcar::Speedbar
    class << self
      attr_accessor :previous_query
      attr_accessor :previous_replace
      attr_accessor :previous_search_type
      attr_accessor :previous_match_case
    end
    
    def after_draw
      self.query.value = SearchAndReplaceSpeedbar.previous_query || ""
      self.replace.value = SearchAndReplaceSpeedbar.previous_replace || ""
      self.search_type.value = SearchAndReplaceSpeedbar.previous_search_type
      self.match_case.value = SearchAndReplaceSpeedbar.previous_match_case
      self.query.edit_view.document.select_all
    end
    
    label :label_search, "Search:"
    textbox :query        
    
    label :label_replace, "Replace:"
    textbox :replace        

    #name, items=[], value=nil, &block
    
    combo :search_type, ['Regex', "Plain"], "RegEx" do |v|
      # v is the value of the combo box value
      puts v
      SearchAndReplaceSpeedbar.previous_search_type = v          
    end
    
    toggle :match_case, 'Match case', nil, false do |v|
      SearchAndReplaceSpeedbar.previous_match_case = v          
    end      
    
    button :single_replace, "Replace", "Return" do
      SearchAndReplaceSpeedbar.previous_query = query.value
      SearchAndReplaceSpeedbar.previous_replace = replace.value
      SearchAndReplaceSpeedbar.previous_match_case = match_case.value
      SearchAndReplaceSpeedbar.previous_search_type = search_type.value || "Regex" # Hack to work around fact that default value not being picked up
      success = SearchAndReplaceSpeedbar.search_replace
    end
    
    button :all_replace, "Replace All", "Return" do
      SearchAndReplaceSpeedbar.previous_query = query.value
      SearchAndReplaceSpeedbar.previous_replace = replace.value
      SearchAndReplaceSpeedbar.previous_match_case = match_case.value
      SearchAndReplaceSpeedbar.previous_search_type = search_type.value || "Regex" # Hack to work around fact that default value not being picked up
      success = SearchAndReplaceSpeedbar.search_replace_all
    end

    def self.search_replace
      puts "query = '#{@previous_query}', replace = '#{@previous_replace}', search_type = '#{@previous_search_type}', match_case = '#{@previous_match_case}' "
      current_query = @previous_query
      current_replace = @previous_replace
      if @previous_is_regex != "Regex"
        current_query = Regexp.escape(current_query)
        current_replace = Regexp.escape(current_replace)
      end
      FindNextRegex.new(Regexp.new(current_query, !@previous_match_case), true).run
    end

    def self.search_replace_all
      puts "query = '#{@previous_query}', replace = '#{@previous_replace}', search_type = '#{@previous_search_type}', match_case = '#{@previous_match_case}' "
      current_query = @previous_query
      current_replace = @previous_replace
      if @previous_is_regex != "Regex"
        current_query = Regexp.escape(current_query)
        current_replace = Regexp.escape(current_replace)
      end
      FindNextRegex.new(Regexp.new(current_query, !@previous_match_case), true).run
    end
  end
  
end