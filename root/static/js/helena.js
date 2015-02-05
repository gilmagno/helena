'use strict';

$(document).ready(function() {
    $('select').select2();

    $(".select-people").select2({
        ajax: {
            url: "/processos/procurar-pessoas",
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term, // search term
                    page: params.page
                };
            },
            processResults: function (data, page) {
                return {
                    results: data.json
                };
            },
            cache: true
        },
        minimumInputLength: 1,
    });

    $(".select-users").select2({
        ajax: {
            url: "/processos/procurar-usuarios",
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    q: params.term, // search term
                    page: params.page
                };
            },
            processResults: function (data, page) {
                return {
                    results: data.json
                };
            },
            cache: true
        },
        minimumInputLength: 1,
    });
});
