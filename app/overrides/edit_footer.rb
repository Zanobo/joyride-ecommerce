Deface::Override.new(:virtual_path => "spree/shared/_footer",
                     :name => "edit_footer",
                     :replace_contents => "#footer-left") do
  '<div id="footer-left" class="columns alpha eight" data-hook>
    <p><%= t(:powered_by) %> <%= link_to "Joyride Coffee", "http://www.joyridecoffeedistributors.com/" %></p>
 </div>'
end