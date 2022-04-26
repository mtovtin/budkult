$(function () {
    const searchForm = $('#documentSearchForm');
    const ajaxCall = (page = '') => {
        $('#docGrid').fadeOut(150);
        $.ajax({
            url: '/filter',
            type: 'post',
            async: true,
            data: page ? searchForm.serialize() + '&page=' + page : searchForm.serialize(),
            success: function (data) {
                $('#docGrid').html(data).fadeIn(150);
            },
            error: function () {
                $('#docGrid').fadeIn(150);
                console.error('connection error');
            }
        });
    };
    searchForm.on('submit', (event) => {
        event.preventDefault();
        event.stopImmediatePropagation();
        ajaxCall()
    })

    // enabling ajax on pagination
    const paginator = document.querySelector('.pagination')
    if (paginator) {
        const paginatorElements = paginator.getElementsByTagName('a')
        for (let element of paginatorElements) {
            element.addEventListener('click', (event) => {
                event.preventDefault();
                let page_num = event.target.href.split('=')[1];
                ajaxCall(page_num);
                return false;
            })
        }
    }
});

