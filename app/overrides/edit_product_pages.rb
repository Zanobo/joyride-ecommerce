Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "edit_product_image_link",
                     :replace_contents => ".product-image") do
              ' <%= link_to image_tag(product.display_image.attachment(:small), itemprop: "image"), url,
                {:remote => true, "data-toggle" =>  "modal", "data-target" => "#myModal"} %>
                <%= product.name%>
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

                </div>
'
end