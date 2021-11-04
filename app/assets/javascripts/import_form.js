$(function () {
    // change date-range picker format dynamically depending on toggle position
    const dateField = $('#import_date_plugin');
    const toggle = document.getElementById('ios-toggle');
    const toggle_published = document.getElementById('ios-toggle_published');
    toggle.checked = true
    toggle_published.checked = false
    dateField.datetimepicker({format: 'YYYY-MM-DD'})
    toggle.addEventListener('change', (event) => {
        let warning_msg =
            'Ви впевнені, що хочете перемикнутися на помісячний режим імпорту? \n\r ' +
            'В цьому режимі будуть імпортовані всі документи за вибраний місяць \n\r' +
            'Процес займає трошки більше часу - декілька хвилин в залежності від кількості документів, і його неможливо зупинити'
        if (!event.target.checked && confirm(warning_msg)) {
            dateField.datetimepicker().data('DateTimePicker').format('YYYY-MM');
        } else {
            event.target.checked = true
            dateField.datetimepicker().data('DateTimePicker').format('YYYY-MM-DD');
        }
    });

    // category search and autocomplete
    const documentCategoryField = document.getElementById('autocomplete');
    // clear the fields on page reload
    documentCategoryField.value = '';
    documentCategoryField.addEventListener('input', (event) => {
        let searchTerm = event.target.value.split(',').at(-1).trim();
        if (searchTerm) {
            ajaxCall(searchTerm)
        }
    });

    // AJAX call requesting the category suggestions for autocompletion
    const ajaxCall = (query) => {
        $.ajax({
            url: 'category_autocompletion',
            type: 'get',
            async: true,
            data: `autocomplete_query=${query}`,
            success: function (data) {
                // A jquery snippet for autocompletion
                autoCompleteWithMultipleSelect('autocomplete', data);
            },
            error: function () {
                console.error('error while retrieving categories for autocomplete');
            }
        });
    };

    // A jQuery snippet enabling the autocomplete dropdown and selection of multiple options
    const autoCompleteWithMultipleSelect = (htmlInputFieldId, availableTags) => {

        function split(val) {
            return val.split(/,\s*/);
        }

        function extractLast(term) {
            return split(term).pop();
        }

        $(`#${htmlInputFieldId}`)
            .autocomplete({
                minLength: 0,
                source: function (request, response) {
                    // delegate back to autocomplete, but extract the last term
                    response($.ui.autocomplete.filter(
                        availableTags, extractLast(request.term)));
                },
                focus: function () {
                    // prevent value inserted on focus
                    return false;
                },
                select: function (event, ui) {

                    var terms = split(this.value);
                    // remove the current input
                    terms.pop();
                    // add the selected item
                    terms.push(ui.item.label);
                    // add placeholder to get the comma-and-space at the end
                    terms.push("");
                    this.value = terms.join(", ");
                    return false;
                }

            });
    }

    // show spinner on import start
    const documentImportForm = document.getElementById('documentImportForm')
    documentImportForm.addEventListener('submit', () => {
        $('#cover-spin').show()
    })
});

