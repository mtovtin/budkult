"use strict";
$(function () {
    let element = $('input[name="date_filter"]')
    element.daterangepicker({
        autoUpdateInput: false,
        showDropdowns: true,
        opens: 'left',
        locale: {
            format: "DD/MM/YYYY",
            separator: " - ",
            applyLabel: "Вибрати",
            cancelLabel: "Відмінити/Очистити",
            fromLabel: "Від",
            toLabel: "До",
            daysOfWeek: ['Нд', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
            monthNames: ['Січень', 'Лютий', 'Березень', 'Квітень', 'Травень', 'Червень', 'Липень', 'Серпень', 'Вересень', 'Жовтень', 'Листопад', 'Грудень'],
            firstDay: 1
        }
    });

    element.on('apply.daterangepicker', function (ev, picker) {
        $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
    });

    element.on('cancel.daterangepicker', function (ev, picker) {
        $(this).val('');
    });
});