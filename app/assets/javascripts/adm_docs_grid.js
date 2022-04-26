jQuery(function () {
    // datetimepicker
    $('#plugin_field_post_created_at').datetimepicker({format: 'YYYY-MM-DD'})

    // submit mass delete button element
    const multiple_destroy_submit_btn = document.getElementById('multiple_destroy_btn');

    // submit the form by clicking a button outside of the form
    jQuery(multiple_destroy_submit_btn).click(() => jQuery('#destroy_multiple_form').submit());

    // check-uncheck all checkboxes
    jQuery('#check_all').on("click", function () {
        let checkboxes = jQuery('input[type="checkbox"]');
        checkboxes.prop("checked", !checkboxes.prop("checked"));
    });

    // updates and displays the quantity of selected documents on delete button
    const list_of_checkboxes = document.querySelectorAll("input[type='checkbox']");

    for (let checkbox of list_of_checkboxes) {
        checkbox.addEventListener('change', () => {
            let quantity = jQuery('input#document_ids_.selectable:checkbox:checked').length
            let postfix = quantity >= 5 ? 'ів' : quantity > 1 ? 'а' : ''
            // toggle disable on submit button
            jQuery(multiple_destroy_submit_btn).prop('disabled', !Boolean(quantity));
            // change the text on submit button
            multiple_destroy_submit_btn.value = quantity ? `Видалити ${quantity} документ${postfix}` : 'Видалити документи'
        })
    }
})