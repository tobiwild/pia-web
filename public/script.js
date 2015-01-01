jQuery(function($) {
    $('body').on('change', '.flipswitch', function() {
        var activate = this.checked,
            name = $(this).attr('name'),
            action;

        if (activate) {
            action = 'activate';
        } else {
            action = 'deactivate'; 
        }
        $.mobile.loading('show', {
            text: action + ' ' + name,
            textVisible: true
        });

        $.post('/'+name+'/'+action, function(data) {
            if (data.result === 'error') {
                alert(data.message);
            }

            reloadServices();
        });
    });

    function reloadServices() {
        $('#services').load('/services', function() {
            $(this).trigger('create');
            $.mobile.loading('hide');
        });
    }

    reloadServices();
});
