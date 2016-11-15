Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "edit_product_image_link",
                     :replace_contents => ".product-image") do
              ' <%= link_to image_tag(product.display_image.attachment(:small), itemprop: "image"), url,
                {:remote => true, "data-toggle" =>  "modal", "data-target" => "#myModal"} %>
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">

                </div>
'
end

Deface::Override.new(:virtual_path => "spree/home/index",
                     :name => "embed_product_modal",
                     :insert_after  => "[data-hook='homepage_products']",
                     :text           => '
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                </div>
')