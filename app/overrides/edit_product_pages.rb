Deface::Override.new(:virtual_path => "spree/shared/_products",
                     :name => "product_override",
                     :replace_contents => ".product-listing") do
  '<% products.each do |product| %>
    <% if product.product_properties.find_by_value("Active") and
      product.properties.find_by_name("Item Status") %>
      <% url = spree.product_path(product, taxon_id: @taxon.try(:id)) %>
      <li id="product_<%= product.id %>" class="columns three <%= cycle("alpha", "secondary", "", "omega secondary", name: "classes") %>" data-hook="products_list_item" itemscope itemtype="http://schema.org/Product">
        <% cache(@taxon.present? ? [I18n.locale, current_pricing_options, @taxon, product] : [I18n.locale, current_pricing_options, product]) do %>
          <div class="product-image">
            <%= link_to image_tag(product.display_image.attachment(:small), itemprop: "image"), url,
            {:remote => true, "data-toggle" =>  "modal", "data-target" => "#myModal"} %>
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"/>
          </div>
          <%= link_to truncate(product.name, length: 50), url, class: "info", itemprop: "name", title: product.name %>
          <span itemprop="offers" itemscope itemtype="http://schema.org/Offer">
            <span class="price selling" itemprop="price"><%= display_price(product) %></span>
          </span>
        <% end %>
      </li>
    <% end %>
    <% end %>
    <% reset_cycle("classes") %>
'
end

Deface::Override.new(:virtual_path => "spree/home/index",
                     :name => "embed_product_modal",
                     :insert_after  => "[data-hook='homepage_products']",
                     :text           => '
                <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                </div>
')
