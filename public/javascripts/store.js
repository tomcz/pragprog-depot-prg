document.observe('dom:loaded', function() {
    $$('form.checkout').each(function(form) {
        Form.focusFirstElement(form);
    });
});
