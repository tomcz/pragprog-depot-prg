document.observe('dom:loaded', function() {
    $$('form.login, form.new_product, form.edit_product, form.new_user, form.edit_user').each(function(form) {
        Form.focusFirstElement(form);
    });
});
