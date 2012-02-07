group.commands.add(['dmark'], "Bookmark page on Delicious",
    function(args) {
        var url = [
            'https://api.del.icio.us/v1/posts/add?',
            '&url=', encodeURIComponent(buffer.URL),
            '&description=', encodeURIComponent(buffer.title),
            '&shared=no',
            '&tags=', encodeURIComponent(args.join(','))
        ];
        url = url.join('');
        var xhr = new XMLHttpRequest();
        xhr.open('POST', url, false);
        xhr.send(null);
        if (xhr.status != 200) {
            dactyl.error("Error creating bookmark");
        } else {
            dactyl.echo("Bookmark added");
        }
    }
);