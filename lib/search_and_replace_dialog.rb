module Redcar
   import org.eclipse.swt.SWT
   import org.eclipse.swt.layout.GridData
   import org.eclipse.swt.layout.GridLayout
   import org.eclipse.swt.widgets.Button
   import org.eclipse.swt.widgets.Composite
   import org.eclipse.swt.widgets.Label
   import org.eclipse.swt.widgets.Shell
   import org.eclipse.swt.widgets.Combo
   import org.eclipse.jface.resource.JFaceResources
   import org.eclipse.swt.graphics.GC

  
 class SearchAndReplaceDialog < JFace::Dialogs::Dialog
    attr_accessor :searchTerms, :replaceTerms
    
    def initialize(parentShell, searchValue = "", initialDirectory = ".")
      super(parentShell)
      @searchValue = searchValue
      @initialDirectory = initialDirectory
    end
        
    protected

    def configureShell(shell) 
       super
       shell.setText("Search and Replace")

       # create the top level composite for the dialog area
       composite = Composite.new(shell, SWT::NONE)
       layout = GridLayout.new
	   layout.marginWidth = 10
	   layout.marginHeight = 10
       layout.numColumns = 3
       composite.setLayout(layout)
      
       searchValue = @searchValue == nil || @searchValue.size() == 0 ? "[Search Text]" : @searchValue
       @searchText = create_text_field_with_label(composite, "Search Term:", searchValue, @searchTerms, 40)
       create_button(composite, "Replace All", 1000, true) do |id|
         puts "Replace All: #{@searchText.getText} with #{@replaceText.getText}"
       end

      
       @replaceText = create_text_field_with_label(composite, "Replace:", "[Replacement Text]", @replaceTerms, 40)
       create_button(composite, "Replace", 1001, false) do |id| 
      	 puts "Replace: #{@searchText.getText} with #{@replaceText.getText}"
       end
     end
    
    def create_text_field_with_label(parent, label, text, data, columns = 16)
       label_ctrl = Label.new(parent, SWT::NONE)
       label_ctrl.setText(label)
       text_ctrl = Combo.new(parent, SWT::BORDER)
       text_ctrl.setItems(data)
  		
       gc = GC.new(text_ctrl)
       fm = gc.getFontMetrics()
	   width = columns * fm.getAverageCharWidth()
	   height = fm.getHeight()
       gc.dispose()
       text_ctrl.setSize(text_ctrl.computeSize(width, height))
       grid_data = GridData.new
       grid_data.widthHint = width
       text_ctrl.setLayoutData(grid_data)
      
       text_ctrl.setText(text)
       return text_ctrl
    end      
    
   def create_button(parent, label, id, defaultButton, &body)
      button = Button.new(parent, SWT::PUSH)
      button.setText(label)
      button.setFont(JFaceResources.getDialogFont())
      button.setData(id)
      button.add_selection_listener do
        begin
          body.call(id)
        rescue => err
          puts err   #TODO: Better error handling
        end
     if(defaultButton)
       Shell shell = parent.getShell()
       if(shell)	then shell.setDefaultButton(button) end
     end
     setButtonLayoutData(button)
     return button
   end
 end
end
end