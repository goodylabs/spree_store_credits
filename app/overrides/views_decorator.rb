Deface::Override.new(:virtual_path => "spree/layouts/admin",
  :name => "store_credits_admin_tabs",
  :insert_bottom => "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
  :text => "<%= tab(:store_credits, :url => spree.admin_store_credits_path, :icon => 'icon-user') %>",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/users/index",
  :name => "store_credits_admin_users_index_row_actions",
  :insert_bottom => "[data-hook='admin_users_index_row_actions']",
  :text => "&nbsp;<%= link_to_with_icon('add', t('add_store_credit'), new_admin_user_store_credit_url(user)) %>",
  :disabled => false)

# Deface::Override.new(
#   :virtual_path => "spree/checkout/_payment",
#   :name => "store_credits_checkout_payment_step",
#   :insert_after => "[data-hook='checkout_payment_step']",
#   :partial => "spree/checkout/store_credits",
#   :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/users/show",
  :name => "store_credits_account_my_orders",
  :insert_after => "[data-hook='account_my_orders']",
  :partial => "spree/users/store_credits",
  :disabled => false)

Deface::Override.new(
  :virtual_path => "spree/admin/general_settings/edit",
  :name => "admin_general_settings_edit_for_sc",
  :insert_before => "[data-hook='buttons']",
  :partial => "spree/admin/store_credits/limit",
  :disabled => true)
