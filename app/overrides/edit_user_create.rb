Deface::Override.new(
    :virtual_path   => "spree/admin/users/_form",
    :name           => "edit_signup_admin",
    :insert_after  => "[data-hook='admin_user_form_roles']",
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

Deface::Override.new(
    :virtual_path   => "spree/admin/users/_form",
    :name           => "add_signup_approval_to_form",
    :insert_before  => "[data-hook='admin_user_form_roles']",
    :text           => "
          <div class='field'>
                <%= f.label :approved %>
            <ul>
                <%= f.check_box :approved, :class => 'fullwidth' %>
            </ul>
          </div>
"
)

Deface::Override.new(
    :virtual_path   => "spree/admin/users/index",
    :name           => "add_signup_approval_head_to_index",
    :insert_before  => "[data-hook='admin_users_index_header_actions']",
    :text           => "
                        <th>
                          <%= sort_link @search, :created_at, 'Created at' %>
                        </th>
                        <th>
                          <%= sort_link @search, :approved, 'Approved?' %>
                        </th>
"
)

Deface::Override.new(
    :virtual_path   => "spree/admin/users/index",
    :name           => "add_signup_approval_to_index",
    :insert_before  => "[data-hook='admin_users_index_row_actions']",
    :text           => "
                        <td class='user_created_at'>
                          <%=user.created_at %>
                        </td>
                        <td class='user_approved'>
                          <%=user.approved %>
                        </td>
"
)

Deface::Override.new(
    :virtual_path   => "spree/shared/_user_form",
    :name           => "edit_signup_form",
    :insert_after  => "erb[loud]:contains('email_field :email')",
    :text           => "
          <p>
                <%= f.label :company_name, Spree.t(:company_name) %><br />
                <%= f.text_field :company_name, class: 'title' %>
          </p>
          <p>
                <%= f.label :first_name, Spree.t(:first_name) %><br />
                <%= f.text_field :first_name, class: 'title' %>
          </p>
          <p>
                <%= f.label :last_name, Spree.t(:last_name) %><br />
                <%= f.text_field :last_name, class: 'title' %>
          </p>
"
)

Deface::Override.new(
    :virtual_path   => "spree/users/show",
    :name           => "edit_signup_show",
    :insert_after  => "erb[loud]:contains('spree.edit_account_path')",
    :text           => "
                        <dt><%= Spree.t(:company_name) %></dt>
                          <dd><%= @user.company_name %> (<%= link_to Spree.t(:edit), spree.edit_account_path %>)</dd>
                        <dt><%= Spree.t(:first_name) %></dt>
                          <dd><%= @user.first_name %> (<%= link_to Spree.t(:edit), spree.edit_account_path %>)</dd>
                        <dt><%= Spree.t(:last_name) %></dt>
                          <dd><%= @user.last_name %> (<%= link_to Spree.t(:edit), spree.edit_account_path %>)</dd>
"
)