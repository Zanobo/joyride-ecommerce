Deface::Override.new(
    :virtual_path   => "spree/admin/users/_form",
    :name           => "edit_signup_admin",
    :insert_bottom  => "[data-hook='admin_user_form_roles']",
    :text           => "
          <div class='field'>
                <%= f.label :company_name %>
                <%= f.text_field :company_name, :class => 'fullwidth' %>
          </div>
          <div class='field'>
                <%= f.label :first_name %>
                <%= f.text_field :first_name, :class => 'fullwidth' %>
          </div>
          <div class='field'>
                <%= f.label :last_name %>
                <%= f.text_field :last_name, :class => 'fullwidth' %>
          </div>
"
)