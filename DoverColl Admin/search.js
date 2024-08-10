function searchAssetPosition(table) {
    $(document).ready(function () {
        $(table).DataTable(
          {
            paging: false,
            info: false,
            ordering:false,
            language: {
              search: "",
              searchPlaceholder: "Search"
            },
    
            dom: 
            "<'row'<'col-sm-6'f><'col-sm-6'l>>" +
            "<'row'<'col-sm-12'tr>>" +
            "<'row'<'col-sm-5'i><'col-sm-7'p>>",
    
            initComplete: function() {
                $('.dataTables_filter input')
                .addClass('form-control mr-sm-0') // Add the Bootstrap form-control class
                .css('margin-left', '270%')
                .css('margin-top', '-50px')
                .width('400px'); 
                }
            });
        });
    }

    function searchPosition(table) {
        $(document).ready(function () {
            $(table).DataTable(
              {
                paging: false,
                info: false,
                ordering:false,
                language: {
                  search: "",
                  searchPlaceholder: "Search"
                },
        
                dom: 
                "<'row'<'col-sm-6'f><'col-sm-6'l>>" +
                "<'row'<'col-sm-12'tr>>" +
                "<'row'<'col-sm-5'i><'col-sm-7'p>>",
        
                initComplete: function() {
                    $('.dataTables_filter input')
                    .addClass('form-control mr-sm-0') // Add the Bootstrap form-control class
                    .css('margin-left', '262%')
                    .css('margin-top', '-50px')
                    .width('400px'); 
                    }
                });
            });
        }
      
        function searchSalaryPosition(table) {
            $(document).ready(function () {
                $(table).DataTable(
                  {
                    paging: false,
                    info: false,
                    ordering:false,
                    language: {
                      search: "",
                      searchPlaceholder: "Search"
                    },
            
                    dom: 
                    "<'row'<'col-sm-6'f><'col-sm-6'l>>" +
                    "<'row'<'col-sm-12'tr>>" +
                    "<'row'<'col-sm-5'i><'col-sm-7'p>>",
            
                    initComplete: function() {
                        $('.dataTables_filter input')
                        .addClass('form-control mr-sm-0') // Add the Bootstrap form-control class
                        .css('margin-left', '295%')
                        .css('margin-top', '-50px')
                        .width('400px'); 
                        }
                    });
                });
            }
          